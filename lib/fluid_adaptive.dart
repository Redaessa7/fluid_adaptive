/// An adaptive layout toolkit for Flutter built around the **available width**
/// rather than the device size: Material 3 window size classes, local-width
/// aware builders, content-width budgeting, fluid clamped sizing and responsive
/// grids.
///
/// Start with `ResponsiveBuilder`, `ResponsiveLayout`, `ResponsiveGridView`
/// and the `context.responsive` extension.
library;

export 'src/breakpoints/breakpoints.dart';
export 'src/breakpoints/window_size_class.dart';
export 'src/core/responsive_config.dart';
export 'src/core/responsive_info.dart';
export 'src/core/responsive_scope.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/num_extensions.dart';
export 'src/math/fluid.dart';
export 'src/math/gutters.dart';
export 'src/tokens/spacing_tokens.dart';
export 'src/widgets/responsive_builder.dart';
export 'src/widgets/responsive_center.dart';
export 'src/widgets/responsive_class_builder.dart';
export 'src/widgets/responsive_flex.dart';
export 'src/widgets/responsive_grid.dart';
export 'src/widgets/responsive_layout.dart';
export 'src/widgets/responsive_sliver_builder.dart';
export 'src/widgets/responsive_sliver_center.dart';
