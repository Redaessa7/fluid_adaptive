/// A modern, robust, and adaptive responsive design toolkit for Flutter.
///
/// Designed to eliminate the limitations of naive screen-scaling packages
/// by utilizing content-budgeting, adaptive layouts, fluid clamped dimensions,
/// and jitter-free window metrics.
library;

// Breakpoints & Classification
export 'src/breakpoints/breakpoints.dart';
export 'src/breakpoints/window_size_class.dart';

// Core State & Scoping
export 'src/core/responsive_info.dart';
export 'src/core/responsive_scope.dart';

// Math, Gutters & Spacing
export 'src/gutters/gutters.dart';
export 'src/spacing/responsive_tokens.dart';
export 'src/spacing/spacing.dart';

// Adaptive Widgets
export 'src/widgets/responsive_builder.dart';
export 'src/widgets/responsive_center.dart';
export 'src/widgets/responsive_flex.dart';
export 'src/widgets/responsive_grid.dart';
export 'src/widgets/responsive_layout.dart';
export 'src/widgets/responsive_padding.dart';
export 'src/widgets/responsive_sliver_center.dart';

// Metrics & Window Lifecycle
export 'src/metrics/responsive_window_gate.dart';
export 'src/metrics/window_metrics_gate.dart';

// Accessible Typography
export 'src/typography/scaled_typography.dart';

// Extensions
export 'src/extensions/context_extensions.dart';
export 'src/extensions/num_extensions.dart';
