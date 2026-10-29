import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/responsive_config.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';

/// Provides a [ResponsiveInfo] to a subtree.
///
/// Created by `ResponsiveBuilder`, `ResponsiveSliverBuilder`,
/// `ResponsiveLayout`, `ResponsiveRowColumn` and the grid widgets. Read it
/// with [ResponsiveScope.of] or `context.responsive`.
final class ResponsiveScope extends InheritedWidget {
  /// Creates a scope that exposes [info] to [child].
  const ResponsiveScope({
    super.key,
    required this.info,
    required super.child,
  });

  /// The snapshot for this subtree.
  final ResponsiveInfo info;

  /// Returns the nearest [ResponsiveInfo].
  ///
  /// Inside a responsive builder this describes the space that subtree gets.
  /// Anywhere else it falls back to the **window** size from
  /// `MediaQuery.sizeOf` and the breakpoints of the nearest
  /// [ResponsiveConfig]. Requires a `MediaQuery` ancestor in that case.
  static ResponsiveInfo of(BuildContext context) {
    final scope = maybeOf(context);
    if (scope != null) return scope;

    final windowSize = MediaQuery.sizeOf(context);
    final breakpoints = ResponsiveConfig.breakpointsOf(context);
    return ResponsiveInfo(
      windowSize: windowSize,
      localSize: windowSize,
      sizeClass: breakpoints.sizeClassFor(windowSize.width),
      breakpoints: breakpoints,
    );
  }

  /// Returns the nearest [ResponsiveInfo], or null when no scope exists.
  static ResponsiveInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveScope>()?.info;
  }

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) => info != oldWidget.info;
}
