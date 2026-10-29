import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';

/// App-wide configuration for `fluid_adaptive`.
///
/// Place it once above your screens (for example in `MaterialApp.builder`).
/// Every widget and extension that does not receive explicit breakpoints then
/// uses the ones given here.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ResponsiveConfig(
///     breakpoints: const ResponsiveBreakpoints(compactMax: 700),
///     child: child!,
///   ),
/// )
/// ```
final class ResponsiveConfig extends InheritedWidget {
  /// Creates a configuration scope.
  const ResponsiveConfig({
    super.key,
    required this.breakpoints,
    required super.child,
  });

  /// Breakpoints used by default in this subtree.
  final ResponsiveBreakpoints breakpoints;

  /// The nearest configured breakpoints, or [ResponsiveBreakpoints.standard].
  static ResponsiveBreakpoints breakpointsOf(BuildContext context) {
    return maybeOf(context)?.breakpoints ?? ResponsiveBreakpoints.standard;
  }

  /// The nearest [ResponsiveConfig], or null when there is none.
  static ResponsiveConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveConfig>();
  }

  @override
  bool updateShouldNotify(ResponsiveConfig oldWidget) =>
      breakpoints != oldWidget.breakpoints;
}
