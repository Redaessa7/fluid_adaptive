# Changelog

## 2.0.0

A cleanup release: one correct way to do each thing, a smaller API, and fixes for
bugs found in 1.x. See [MIGRATION.md](MIGRATION.md).

### Fixed
- **`ResponsiveSliverGrid` crashed inside a `CustomScrollView`** (it returned a sliver from a
  `LayoutBuilder`). It is now built on the new `ResponsiveSliverBuilder` and has a test.
- **Double text scaling.** `16.sp(context)`, `ResponsiveTypography.scaled*` and
  `TextStyle.responsiveScale` pre-scaled font sizes, but `Text` applies the system text scaler again, so
  text grew by the square of the user's setting. They are removed. To cap text scaling use Flutter's
  `MediaQuery.withClampedTextScaling`; for non-text sizes use the new `num.textScaled(context)`.
- `ResponsiveSliverCenter` / grids now measure the real sliver cross-axis extent.

### Removed (breaking)
- `ResponsiveWindowGate` and `RotationRebuildGate`: its rebuild had no effect and `MediaQuery.sizeOf` already
  ignores keyboard changes. Use `ResponsiveConfig` for app-wide breakpoints.
- `ResponsiveTypography`, `TextStyle.responsiveScale`, `num.sp` (see Fixed).
- `ResponsiveGutterPadding` (use `Padding(padding: context.responsive.gutters())`).
- `ResponsiveRadiusTokens`, `ResponsiveInfo.radius`, `ResponsiveSpacing.radiusFor` (not responsive, out of scope).
- Duplicate or overlapping helpers: `isPhone` / `isTablet` / `isDesktop`, `ResponsiveInfo.when`,
  `.spacing()`, `.directionalGutters()`, `.aspectRatio`, `.windowWidth` / `.windowHeight`,
  `ResponsiveBreakpoints.isWide` / `guttersFor`, `ResponsiveGutters.directional`,
  `ResponsiveSpacing.*` (replaced by `ResponsiveFluid` and the spacing tokens),
  `context.responsiveGutter` / `responsiveFluid` / `responsiveColumns` / `responsiveSpacing`,
  `num.responsiveGapW` / `responsiveGapH`.
- `ResponsiveSpacingTokens.step*` constants.

### Changed (breaking)
- `num.w` / `num.h` are now `widthPercent(context)` / `heightPercent(context)` (they clashed with
  `flutter_screenutil` and meant something different).
- `num.responsive(context, {tablet, desktop, large})` is now `{medium, expanded, large}`, matching the size classes.
- `ResponsiveSpacingTokens` is an immutable value (no `BuildContext` inside): `context.spacing` is unchanged.
- `ResponsiveSpacing.fluid` is now `ResponsiveFluid.clampedLerp`.
- `ResponsiveSliverCenter` no longer takes `breakpoints`.
- Core value classes are `final class`es.

### Added
- `ResponsiveSliverBuilder`, the sliver counterpart of `ResponsiveBuilder`.
- `num.textScaled(context, {maxScaleFactor})`.
- Strict analysis (`strict-casts`, `strict-raw-types`) and the `public_member_api_docs` lint; the package no
  longer depends on Material or Cupertino, only on the widgets layer.
- Test suite rewritten around the new API.


## 1.1.0

### Added
- `ResponsiveConfig` and `ResponsiveWindowGate(breakpoints: ...)`: set breakpoints once for the whole app.
- `ResponsiveClassBuilder`: rebuilds only when the size class changes (cheaper window resizing on desktop/web).
- `ResponsiveInfo.fromSize(...)` for unit tests, goldens and previews.
- `ResponsiveBreakpoints.copyWith` and `toString`.

### Safety
- No more release-mode crashes from odd input: `columnsFor` (min > max columns, NaN/infinite/zero widths),
  `fluid` (degenerate width range), `radiusFor` (zero divisor), `sideOf` (infinite width), `sp` / `scaled`
  (inconsistent scale factors). Developer mistakes still trip an `assert` in debug.
- `ResponsiveCenter` asserts `maxWidth > 0`.

### Deprecated (removed in 2.0.0)
- `RotationRebuildGate.phonePortraitDesign`, `phoneLandscapeDesign`, `wideWindowThreshold`, `designSizeFor`
  (design-size scaling is not part of this package).
- `ResponsiveWindowGate.debounceDuration` (no effect).

### Internal cleanup
- Magic numbers (375, 812, 170, 720, 0.85, 1.35, ...) live in one internal `ResponsiveDefaults` class.
- `ResponsiveGridView` and `ResponsiveSliverGrid` share one column/delegate implementation.
- `num.fluid` delegates to `ResponsiveInfo.fluid`, so its default `maxWidth` follows the active breakpoints
  (`minWidth` / `maxWidth` parameters are now nullable; passing doubles still works).
- `ResponsiveSpacingTokens` resolves wide/compact once per getter; removed `catch (_)` blocks in
  `ResponsiveTypography` that could never trigger and would only have hidden real errors.

### Packaging
- Shorter pubspec description (pub.dev requires <= 180 characters), `topics`, `issue_tracker`.
- `flutter_lints` constraint widened so the package can be developed on its minimum SDK.

### Also in this release (previously prepared as 1.0.1)

- Lowered the SDK floor to `^3.2.0` (the code needs nothing newer); `1.0.0` required `^3.13.5`.
- `ResponsiveWindowGate` is now optional and honest: it only reports genuine window-size changes via
  `onWindowChanged`. It no longer calls a no-op `setState`; `debounceDuration` is deprecated and ignored.
- `ResponsiveGridView` / `ResponsiveSliverGrid` now account for `crossAxisSpacing` and `padding`, so tiles are
  really at least `minTileWidth` wide. `columnsFor` / `ResponsiveInfo.columns` gained optional `spacing` / `padding`.
- `ResponsiveSliverCenter` now exposes the viewport height instead of `0`.
- `sp()` default `maxScaleFactor` raised from `1.5` to `2.0` (consistent with `ResponsiveTypography`).
- README / example: fixed the double-budgeting pattern (`ResponsiveCenter` + gutters), documented
  local-vs-window width, `flutter_screenutil` name clashes, and removed unverified performance claims.

## 1.0.0

- Initial stable release of `fluid_adaptive`.
- Core responsive layout engine based on Material 3 window size classes (`compact`, `medium`, `expanded`, `large`).
- Content budgeting via `ResponsiveCenter` and `ResponsiveGutters`.
- Jitter-free `ResponsiveWindowGate` and `RotationRebuildGate` preventing keyboard rebuild storms.
- Adaptive widget suite: `ResponsiveBuilder`, `ResponsiveLayout`, `ResponsiveRowColumn`, `ResponsiveGridView`, `ResponsiveSliverGrid`, and `ResponsiveGutterPadding`.
- Fluid clamped dimension interpolation (`fluid`) preventing ballooning on tablets.
- Accessible typography scaling respecting `MediaQuery.textScalerOf`.
- Fluent `BuildContext` extensions.
