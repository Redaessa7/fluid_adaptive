import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';
import 'package:fluid_adaptive/src/spacing/spacing.dart';

/// Complete snapshot of the responsive metrics for the active subtree.
///
/// Contains both [localSize] (granted by the parent widget / [LayoutBuilder])
/// and [windowSize] (the whole app window via [MediaQuery.sizeOf]).
/// This ensures nested widgets (like split views, sheets, or sidebars)
/// adapt to their actual bounding box rather than assuming they own the whole screen.
@immutable
class ResponsiveInfo {
  const ResponsiveInfo({
    required this.windowSize,
    required this.localSize,
    required this.sizeClass,
    this.breakpoints = ResponsiveBreakpoints.standard,
  });

  /// The full app window size (from [MediaQuery.sizeOf]).
  final Size windowSize;

  /// The size available to the local subtree (from [LayoutBuilder]).
  final Size localSize;

  /// The active [WindowSizeClass] based on [localSize.width].
  final WindowSizeClass sizeClass;

  /// The active breakpoint configuration.
  final ResponsiveBreakpoints breakpoints;

  /// Available width in logical dp for this subtree.
  double get localWidth => localSize.width;

  /// Available height in logical dp for this subtree.
  double get localHeight => localSize.height;

  /// Total width of the application window in logical dp.
  double get windowWidth => windowSize.width;

  /// Total height of the application window in logical dp.
  double get windowHeight => windowSize.height;

  /// True when local width is in phone range (< [breakpoints.compactMax]).
  bool get isCompact => sizeClass.isCompact;

  /// True when local width is in small tablet range ([breakpoints.compactMax] to [breakpoints.mediumMax]).
  bool get isMedium => sizeClass.isMedium;

  /// True when local width is in large tablet range ([breakpoints.mediumMax] to [breakpoints.expandedMax]).
  bool get isExpanded => sizeClass.isExpanded;

  /// True when local width is large desktop range (>= [breakpoints.expandedMax]).
  bool get isLarge => sizeClass.isLarge;

  /// True when local width allows multi-column layouts (>= [breakpoints.compactMax]).
  bool get isWide => sizeClass.isWide;

  /// True if local layout is phone-sized.
  bool get isPhone => isCompact;

  /// True if local layout is tablet-sized (medium or expanded).
  bool get isTablet => sizeClass.isTablet;

  /// True if local layout is desktop-sized (large).
  bool get isDesktop => isLarge;

  /// True if the local width is greater than height.
  bool get isLandscape => localSize.width > localSize.height;

  /// True if the local height is greater than or equal to width.
  bool get isPortrait => !isLandscape;

  /// Local aspect ratio (width / height).
  double get aspectRatio =>
      localSize.height <= 0 ? 0.0 : localSize.width / localSize.height;

  /// Computes the horizontal gutter for the current local width.
  double gutter({double compact = 16.0, double? contentMaxWidth}) {
    return ResponsiveGutters.sideOf(
      localSize.width,
      gutter: compact,
      contentMaxWidth: contentMaxWidth ?? breakpoints.contentMaxWidth,
    );
  }

  /// Computes symmetric horizontal EdgeInsets for the current local width.
  EdgeInsets gutters({
    double compact = 16.0,
    double? contentMaxWidth,
    double vertical = 0.0,
  }) {
    return ResponsiveGutters.horizontal(
      localSize.width,
      gutter: compact,
      contentMaxWidth: contentMaxWidth ?? breakpoints.contentMaxWidth,
      vertical: vertical,
    );
  }

  /// Computes directional EdgeInsetsDirectional for the current local width.
  EdgeInsetsDirectional directionalGutters({
    double compact = 16.0,
    double? contentMaxWidth,
    double top = 0.0,
    double bottom = 0.0,
  }) {
    return ResponsiveGutters.directional(
      localSize.width,
      gutter: compact,
      contentMaxWidth: contentMaxWidth ?? breakpoints.contentMaxWidth,
      top: top,
      bottom: bottom,
    );
  }

  /// Automatically computes column count for grid layouts based on [localWidth].
  int columns({
    double minTileWidth = 170.0,
    int minColumns = 2,
    int maxColumns = 8,
  }) {
    return breakpoints.columnsFor(
      localSize.width,
      minTileWidth: minTileWidth,
      minColumns: minColumns,
      maxColumns: maxColumns,
    );
  }

  /// Returns fluid clamped sizing interpolated according to [localWidth].
  double fluid({
    required double min,
    required double max,
    double? minWidth,
    double? maxWidth,
  }) {
    return ResponsiveSpacing.fluid(
      width: localSize.width,
      min: min,
      max: max,
      minWidth: minWidth ?? 375.0,
      maxWidth: maxWidth ?? breakpoints.expandedMax,
    );
  }

  /// Resolves standard stepped spacing based on [localWidth].
  double spacing({
    double compact = 12.0,
    double medium = 16.0,
    double expanded = 24.0,
  }) {
    return ResponsiveSpacing.spacingFor(
      localSize.width,
      compact: compact,
      medium: medium,
      expanded: expanded,
      compactBreakpoint: breakpoints.compactMax,
      mediumBreakpoint: breakpoints.mediumMax,
    );
  }

  /// Resolves clamped border radius based on [localWidth].
  double radius({
    double min = 12.0,
    double max = 28.0,
    double divisor = 40.0,
  }) {
    return ResponsiveSpacing.radiusFor(
      localSize.width,
      min: min,
      max: max,
      divisor: divisor,
    );
  }

  /// Resolves a value according to the active [sizeClass].
  T value<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    return sizeClass.resolve(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
    );
  }

  /// Declarative builder switching for widgets based on the active [sizeClass].
  Widget when({
    required Widget Function() compact,
    Widget Function()? medium,
    Widget Function()? expanded,
    Widget Function()? large,
  }) {
    final builder = sizeClass.resolve(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
    );
    return builder();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveInfo &&
          windowSize == other.windowSize &&
          localSize == other.localSize &&
          sizeClass == other.sizeClass &&
          breakpoints == other.breakpoints;

  @override
  int get hashCode =>
      Object.hash(windowSize, localSize, sizeClass, breakpoints);

  @override
  String toString() =>
      'ResponsiveInfo(sizeClass: $sizeClass, localSize: $localSize, windowSize: $windowSize)';
}
