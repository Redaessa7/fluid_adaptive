import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';

/// Provides [ResponsiveInfo] down the widget tree using an [InheritedWidget].
///
/// Can be accessed via [ResponsiveScope.of(context)] or `context.responsive`.
class ResponsiveScope extends InheritedWidget {
  const ResponsiveScope({
    super.key,
    required this.info,
    required super.child,
  });

  /// The active responsive snapshot for this subtree.
  final ResponsiveInfo info;

  /// Returns the nearest [ResponsiveInfo] in the widget tree.
  ///
  /// If no [ResponsiveScope] is found above the widget, this falls back
  /// gracefully to a window-level [ResponsiveInfo] derived from [MediaQuery.sizeOf],
  /// avoiding runtime assertion crashes while still encouraging [ResponsiveBuilder]
  /// for constraint-based adaptive nesting.
  static ResponsiveInfo of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    if (scope != null) {
      return scope.info;
    }

    // Graceful fallback: window-level info via MediaQuery
    final windowSize = MediaQuery.sizeOf(context);
    final breakpoints = ResponsiveBreakpoints.standard;
    return ResponsiveInfo(
      windowSize: windowSize,
      localSize: windowSize,
      sizeClass: breakpoints.sizeClassFor(windowSize.width),
      breakpoints: breakpoints,
    );
  }

  /// Returns the nearest [ResponsiveInfo], or null if no [ResponsiveScope] exists.
  static ResponsiveInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveScope>()?.info;
  }

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) => info != oldWidget.info;
}
