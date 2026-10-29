# Fluid Adaptive for Flutter

[![pub package](https://img.shields.io/pub/v/fluid_adaptive.svg)](https://pub.dev/packages/fluid_adaptive)
[![CI](https://github.com/redaessa7/fluid_adaptive/actions/workflows/ci.yml/badge.svg)](https://github.com/redaessa7/fluid_adaptive/actions/workflows/ci.yml)
![Dart](https://img.shields.io/badge/Dart-3.2%2B-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.16%2B-02569B.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)

An adaptive layout toolkit for Flutter built around the **available width**, not the device:
Material 3 window size classes, builders that measure the space they really get, content-width
budgeting, clamped fluid sizing, and responsive grids.

<!-- TODO: add screenshots / GIF here (phone, tablet, desktop of the same screen),
     then list them under `screenshots:` in pubspec.yaml so pub.dev shows them. -->

## When to use it (and when not to)

| | Scaling libraries (`flutter_screenutil` style) | `fluid_adaptive` |
|---|---|---|
| Idea | Multiply every value by `screenWidth / designWidth` | Choose the layout by available width; keep control sizes ergonomic |
| Best for | Phone-only apps that must match a fixed Figma design pixel for pixel | Apps that also run on tablets, foldables, web and desktop |
| On a tablet | Everything grows unless you cap it yourself | Same control sizes, more columns, capped content width |
| Nested panels | Uses the screen width | Uses the width the subtree gets, **inside the builder widgets** |

Both approaches are valid. Scaling is simpler for phone-only apps; this package pays off once the UI has to
change *shape* across window sizes.

## Install

```yaml
dependencies:
  fluid_adaptive: ^2.0.0
```

Requires Flutter 3.16+ / Dart 3.2+. Pure Flutter widgets layer: no Material or Cupertino dependency.
Coming from 1.x? See [MIGRATION.md](MIGRATION.md).

## Key concepts

### Window size classes (Material 3)

| Class | Width | Typical device |
|---|---|---|
| `compact` | `< 600dp` | Phones |
| `medium` | `600 - 839dp` | Small tablets, unfolded foldables, landscape phones |
| `expanded` | `840 - 1199dp` | Large tablets, small laptops |
| `large` | `>= 1200dp` | Desktop windows |

### Local width vs window width (read this once)

`context.responsive`, `context.isCompact`, `16.fluid(context, ...)` and the other context-based helpers return:

- **inside** `ResponsiveBuilder`, `ResponsiveSliverBuilder`, `ResponsiveLayout`, `ResponsiveRowColumn`,
  `ResponsiveGridView` or `ResponsiveSliverGrid`: the size of **that subtree**;
- **anywhere else**: the size of the **whole window** (`MediaQuery.sizeOf`).

A screen built straight from `build(context)` therefore sees the window. Wrap a subtree in `ResponsiveBuilder`
when it can be narrower than the window (side panels, dialogs, split views).
`ResponsiveBuilder` uses a `LayoutBuilder`, so it cannot be placed under `IntrinsicHeight` / `IntrinsicWidth`.

### Content width: choose the right tool

| Content | Use | Why |
|---|---|---|
| A box (form, card, detail page) | `ResponsiveCenter(maxWidth: 800, child: ...)` | Caps and centres the box |
| A scrollable (list, grid) | `ListView(padding: context.responsive.gutters(contentMaxWidth: 800), ...)` | The scroll view keeps the full width, so scrollbars and gestures stay at the screen edge |
| A `CustomScrollView` | `ResponsiveSliverCenter(sliver: ...)` | Same idea for slivers |

Use **one** of them for the same content. Stacking them shrinks it twice.

## Quick start

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveCenter(
        maxWidth: 800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Welcome',
                style: context.responsiveValue(
                  compact: Theme.of(context).textTheme.headlineSmall,
                  medium: Theme.of(context).textTheme.headlineMedium,
                  expanded: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              context.spacing.md.gapH,
              // Column on phones, Row from 600dp up
              const ResponsiveRowColumn(
                spacing: 16,
                children: [
                  ResponsiveRowColumnItem(rowFlex: 1, child: FilterSidebar()),
                  ResponsiveRowColumnItem(rowFlex: 3, child: MainFeed()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Widgets

```dart
// Pick a layout by available width (a missing larger one falls back to the nearest smaller one)
ResponsiveLayout(
  compact: (context) => const MobileLayout(),
  medium: (context) => const TabletLayout(),
  expanded: (context) => const DesktopLayout(),
)

// Grid: every tile is at least minTileWidth wide (spacing and padding included)
ResponsiveGridView.builder(
  minTileWidth: 170,
  itemCount: items.length,
  itemBuilder: (context, i) => ItemCard(items[i]),
)

// Same for CustomScrollView
ResponsiveSliverGrid.builder(itemCount: items.length, itemBuilder: (context, i) => ItemCard(items[i]))

// Build from the space you get
ResponsiveBuilder(builder: (context, info) => Text('${info.localWidth} dp'))
ResponsiveSliverBuilder(builder: (context, info) => SliverToBoxAdapter(child: ...))

// Rebuild only when the size class changes (see Performance)
ResponsiveClassBuilder(builder: (context, sizeClass) => ...)
```

Also: `ResponsiveCenter`, `ResponsiveSliverCenter`, `ResponsiveRowColumn`.

## BuildContext helpers

```dart
context.isCompact   // < 600dp
context.isMedium    // 600 - 839dp
context.isExpanded  // 840 - 1199dp
context.isLarge     // >= 1200dp
context.isWide      // >= 600dp
context.isLandscape / context.isPortrait

context.responsiveValue<int>(compact: 1, medium: 2, expanded: 4);
context.spacing.md                       // 16 compact, 20 wide (xs, sm, md, lg, xl, xxl)
context.responsive.columns(minTileWidth: 180);
context.responsive.fluid(min: 14, max: 20);
context.responsive.gutters(vertical: 16);
```

## Numeric helpers

```dart
EdgeInsets.all(16.fluid(context, max: 24))        // 16 -> 24 between 375dp and the expanded breakpoint, clamped
200.responsive(context, medium: 320, large: 450)  // value per size class (falls back to smaller classes)
150.clampedW(context)                             // scales with width, factor clamped to [0.85, 1.35]
50.widthPercent(context)                          // 50% of the available width
24.textScaled(context, maxScaleFactor: 2)         // follows the system text scale (non-text sizes only)
16.gapH   24.gapW                                 // SizedBox shortcuts
```

### Text scaling: do not pre-scale font sizes

`Text` already multiplies `fontSize` by the user's text scale. Passing a pre-scaled size makes text grow by the
*square* of the setting, so `fontSize: 16.textScaled(context)` is **wrong**. Use a plain `fontSize` and, if you
must limit growth, let Flutter do it:

```dart
MediaQuery.withClampedTextScaling(maxScaleFactor: 2.0, child: ...)
```

`textScaled` is for sizes that are not text: icon sizes, minimum tap-target heights, avatars.

## App-wide breakpoints

```dart
MaterialApp(
  builder: (context, child) => ResponsiveConfig(
    breakpoints: const ResponsiveBreakpoints(compactMax: 700, mediumMax: 1000, expandedMax: 1400),
    child: child!,
  ),
  home: const HomeScreen(),
)
```

Everything without explicit breakpoints uses them; a widget's own `breakpoints:` argument still wins.

## Performance

The package is plain arithmetic plus `LayoutBuilder`. The only real cost is that the builder widgets rebuild their
subtree whenever the available size changes: rare on phones, every frame while a desktop/web window is dragged.
For heavy screens use `ResponsiveClassBuilder`, which rebuilds **only when the size class changes**. It only
gives you the size class; use `ResponsiveBuilder` when you need the exact width.
Measure your own screens with Flutter DevTools; we do not claim fixed numbers.

## Testing your layouts

```dart
// Pure unit test, no widget tree:
final info = ResponsiveInfo.fromSize(const Size(700, 900));
expect(info.isMedium, isTrue);

// Widget test at a given window size:
testWidgets('shows the sidebar on tablets', (tester) async {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: MyScreen()));
  expect(find.byType(FilterSidebar), findsOneWidget);
});
```

## Coming from `flutter_screenutil`?

| screenutil | fluid_adaptive |
|---|---|
| `16.w` / `16.h` (scale by design size) | `16.fluid(context, max: 24)` or `16.clampedW(context)` for a bounded scale; plain `16` for fixed sizes |
| `14.sp` | plain `fontSize: 14` (Flutter applies the text scale); `MediaQuery.withClampedTextScaling` to cap it |
| `ScreenUtilInit(designSize: ...)` | nothing to initialise |
| separate tablet layout by hand | `ResponsiveLayout`, `ResponsiveRowColumn`, `ResponsiveGridView` |

None of the extension names (`responsive`, `fluid`, `clampedW`, `widthPercent`, `textScaled`, `gapW`, ...) is one of screenutil's `.w` / `.h` / `.sp` / `.r`, so you can usually import both packages in the same file while you migrate.

## Stability and support policy

- **Semantic versioning.** Patch = fixes, minor = additive features, major = breaking changes. Public APIs are
  deprecated for at least one minor release before removal in the next major.
- **Supported SDKs.** Flutter 3.16+ / Dart 3.2+. CI runs the tests on the minimum and on current stable.
- **Platforms.** Pure Dart/Flutter, no native code: Android, iOS, web, Windows, macOS, Linux.
- **Safety.** Odd input (zero, negative, NaN or infinite sizes) falls back to safe values in release builds;
  developer mistakes trip an `assert` in debug.
- **Reporting issues.** See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## Production checklist

- Pin a version range (`^2.0.0`) and commit your `pubspec.lock`.
- Wrap subtrees that can be narrower than the window in `ResponsiveBuilder`.
- One content-width mechanism per piece of content.
- Prefer fixed sizes for controls; use `fluid` only where growth is intended.
- Test at least three widths (for example 360, 800 and 1280).
- Test with large system font sizes.

## Known limitations

- Sliver widgets (`ResponsiveSliverBuilder`, `ResponsiveSliverGrid`, `ResponsiveSliverCenter`) support vertically
  scrolling viewports.
- Window size is read from `MediaQuery`; multi-window desktop setups are not specifically handled.

## Development

```bash
flutter pub get
flutter analyze
flutter test
```

## License

MIT. Created by Reda Essa.
