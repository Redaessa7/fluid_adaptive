import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// Switches between layouts according to the available width.
///
/// A missing larger layout falls back to the nearest smaller one:
/// [large] to [expanded] to [medium] to [compact].
class ResponsiveLayout extends StatelessWidget {
  /// Creates a layout switch. Only [compact] is required.
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.breakpoints,
  });

  /// Layout for compact widths (< 600dp). Also the final fallback.
  final WidgetBuilder compact;

  /// Layout for medium widths (600dp - 839dp).
  final WidgetBuilder? medium;

  /// Layout for expanded widths (840dp - 1199dp).
  final WidgetBuilder? expanded;

  /// Layout for large widths (>= 1200dp).
  final WidgetBuilder? large;

  /// Breakpoints to use; defaults to the nearest `ResponsiveConfig`, then
  /// [ResponsiveBreakpoints.standard].
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final builder = info.sizeClass.resolve<WidgetBuilder>(
          compact: compact,
          medium: medium,
          expanded: expanded,
          large: large,
        );
        return builder(context);
      },
    );
  }
}
