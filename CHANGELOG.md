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


## 1.0.0

- Initial stable release of `fluid_adaptive`.
- Core responsive layout engine based on Material 3 window size classes (`compact`, `medium`, `expanded`, `large`).
- Content budgeting via `ResponsiveCenter` and `ResponsiveGutters`.
- Jitter-free `ResponsiveWindowGate` and `RotationRebuildGate` preventing keyboard rebuild storms.
- Adaptive widget suite: `ResponsiveBuilder`, `ResponsiveLayout`, `ResponsiveRowColumn`, `ResponsiveGridView`, `ResponsiveSliverGrid`, and `ResponsiveGutterPadding`.
- Fluid clamped dimension interpolation (`fluid`) preventing ballooning on tablets.
- Accessible typography scaling respecting `MediaQuery.textScalerOf`.
- Fluent `BuildContext` extensions.
