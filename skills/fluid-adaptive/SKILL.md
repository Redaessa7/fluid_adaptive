---
name: fluid-adaptive
description: "Coding guide for building adaptive Flutter layouts with fluid_adaptive 2.x: window size classes, local-width builders, content-width budgeting, responsive grids, and correct text scaling."
---

# fluid_adaptive 2.x guide

Use when writing Flutter UI that must work on phones, tablets, foldables, web and desktop.

## Principles
- Decide layout by **available width**, not device type. Phones keep a compact rhythm; wider windows get more
  columns and a capped content width, not bigger controls.
- Size classes: `context.isCompact` (<600), `isMedium` (600-839), `isExpanded` (840-1199), `isLarge` (>=1200),
  `isWide` (>=600).

## Local vs window width
`context.responsive` is the **local** size inside `ResponsiveBuilder` / `ResponsiveSliverBuilder` /
`ResponsiveLayout` / `ResponsiveRowColumn` / grids, and the **window** size everywhere else. Wrap panels that can
be narrower than the window in `ResponsiveBuilder`.

## Content width: one mechanism only
- Box: `ResponsiveCenter(maxWidth: 800, child: ...)`
- Scrollable: `padding: context.responsive.gutters(contentMaxWidth: 800)`
- CustomScrollView: `ResponsiveSliverCenter(sliver: ...)`
Never combine them for the same content.

## Building blocks
- `ResponsiveLayout(compact:, medium:, expanded:, large:)` picks a layout (missing larger ones fall back).
- `ResponsiveRowColumn` is a Column on phones and a Row from 600dp.
- `ResponsiveGridView.builder(minTileWidth: 170, ...)` / `ResponsiveSliverGrid.builder(...)`.
- `ResponsiveClassBuilder` rebuilds only when the size class changes (heavy screens on desktop/web).
- `context.spacing.md`, `context.responsiveValue(compact:, medium:, expanded:, large:)`.
- `16.fluid(context, max: 24)`, `100.responsive(context, medium: 150)`, `100.clampedW(context)`,
  `50.widthPercent(context)`, `16.gapH`.

## Text scaling (important)
`Text` already applies the user's text scale. Never pass a pre-scaled value to `TextStyle.fontSize`. Cap growth
with `MediaQuery.withClampedTextScaling(maxScaleFactor: 2.0, child: ...)`. `24.textScaled(context)` is only for
non-text sizes (icons, tap targets).

## App-wide breakpoints
`MaterialApp(builder: (context, child) => ResponsiveConfig(breakpoints: ..., child: child!))`.

## Testing
`ResponsiveInfo.fromSize(const Size(700, 900))` for unit tests; `tester.view.physicalSize` for widget tests.
