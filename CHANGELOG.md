# Changelog

## 1.0.0

- Initial stable release of `fluid_adaptive`.
- Core responsive layout engine based on Material 3 window size classes (`compact`, `medium`, `expanded`, `large`).
- Content budgeting via `ResponsiveCenter` and `ResponsiveGutters`.
- Jitter-free `ResponsiveWindowGate` and `RotationRebuildGate` preventing keyboard rebuild storms.
- Adaptive widget suite: `ResponsiveBuilder`, `ResponsiveLayout`, `ResponsiveRowColumn`, `ResponsiveGridView`, `ResponsiveSliverGrid`, and `ResponsiveGutterPadding`.
- Fluid clamped dimension interpolation (`fluid`) preventing ballooning on tablets.
- Accessible typography scaling respecting `MediaQuery.textScalerOf`.
- Fluent `BuildContext` extensions.
