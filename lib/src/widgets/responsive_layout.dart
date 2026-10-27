import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// Declaratively switches between widget layouts based on the active [WindowSizeClass].
///
/// Unspecified larger layouts automatically fall back to the nearest available smaller layout:
/// - [large] falls back to [expanded], then [medium], then [compact].
/// - [expanded] falls back to [medium], then [compact].
/// - [medium] falls back to [compact].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.breakpoints,
  });

  /// Widget builder for phone/compact viewports (< 600dp). Required as base layout.
  final WidgetBuilder compact;

  /// Optional widget builder for small tablets / landscape phones (600dp - 839dp).
  final WidgetBuilder? medium;

  /// Optional widget builder for large tablets / small laptops (840dp - 1199dp).
  final WidgetBuilder? expanded;

  /// Optional widget builder for desktop / ultra-wide screens (>= 1200dp).
  final WidgetBuilder? large;

  /// Optional custom breakpoints. Defaults to [ResponsiveBreakpoints.standard].
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
