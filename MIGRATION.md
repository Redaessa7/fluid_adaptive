# Migrating from 1.x to 2.0

2.0 removes duplicate APIs and fixes two real bugs. Most apps need only the renames below.

## Bugs you were probably hitting

**1. Text scaled twice.** `fontSize: 16.sp(context)` (and `ResponsiveTypography.scaled*`) returned a size already
multiplied by the user's text scale, and `Text` multiplies it again. Replace with a plain `fontSize: 16`.
To cap how large text may grow, wrap the subtree:

```dart
MediaQuery.withClampedTextScaling(maxScaleFactor: 2.0, child: ...)
```

For sizes that are not text (icons, tap targets) use `24.textScaled(context, maxScaleFactor: 2)`.

**2. `ResponsiveSliverGrid` threw inside a `CustomScrollView`.** Fixed, no code change needed.

## Renames

| 1.x | 2.0 |
|---|---|
| `50.w(context)` / `30.h(context)` | `50.widthPercent(context)` / `30.heightPercent(context)` |
| `200.responsive(context, tablet: 320, desktop: 450)` | `200.responsive(context, medium: 320, large: 450)` |
| `16.sp(context)` | plain `16` in `TextStyle`; `16.textScaled(context)` for non-text sizes |
| `ResponsiveSpacing.fluid(...)` | `ResponsiveFluid.clampedLerp(...)` |
| `ResponsiveGutters.defaultContentMaxWidth` | `ResponsiveBreakpoints.standard.contentMaxWidth` |
| `context.isPhone` / `isTablet` / `isDesktop` | `context.isCompact` / `context.isMedium \|\| context.isExpanded` / `context.isLarge` |
| `context.responsiveFluid(min:, max:)` | `context.responsive.fluid(min:, max:)` |
| `context.responsiveColumns(...)` | `context.responsive.columns(...)` |
| `context.responsiveGutter(...)` | `context.responsive.gutter(...)` |
| `context.responsiveSpacing(...)` | `context.spacing.md` (the spacing tokens) |
| `info.windowWidth` / `info.windowHeight` | `info.windowSize.width` / `info.windowSize.height` |
| `info.directionalGutters(...)` | `info.gutters(...)` (the insets are symmetric) |
| `info.when(...)` | `info.value<Widget Function()>(...)()` or `ResponsiveLayout` |
| `ResponsiveGutterPadding(child: x)` | `Padding(padding: context.responsive.gutters(), child: x)` |
| `ResponsiveSliverCenter(breakpoints: ...)` | remove the argument |

## Removed without replacement

- `ResponsiveWindowGate`, `RotationRebuildGate`. They had no effect on rebuilds. For app-wide breakpoints use
  `ResponsiveConfig` (for example in `MaterialApp.builder`). For window-size callbacks use a
  `WidgetsBindingObserver`.
- `ResponsiveRadiusTokens`, `ResponsiveInfo.radius`, `ResponsiveSpacing.radiusFor`,
  `ResponsiveSpacing.spacingFor` / `sectionGapFor` / `contentPaddingFor`, `ResponsiveSpacingTokens.step*`.
  Use the spacing tokens (`context.spacing`) and your own theme for radii.
- `num.responsiveGapW` / `responsiveGapH`: use `SizedBox(width: 8.responsive(context, medium: 16))`.

## Behaviour notes

- `ResponsiveSpacingTokens` no longer holds a `BuildContext`; `context.spacing.md` works as before.
- Pick one content-width mechanism per screen: `ResponsiveCenter` for boxes, gutters
  (`context.responsive.gutters()` or `ResponsiveSliverCenter`) for scrollables.
