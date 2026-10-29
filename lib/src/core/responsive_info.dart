import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';
import 'package:fluid_adaptive/src/math/fluid.dart';
import 'package:fluid_adaptive/src/math/gutters.dart';

/// Snapshot of the responsive metrics for a subtree.
///
/// [localSize] is the space the subtree really gets (from a `LayoutBuilder`),
/// [windowSize] is the whole app window. Nested panels, sheets and sidebars
/// should adapt to [localSize], not to the device.
@immutable
final class ResponsiveInfo {
  /// Creates a snapshot. Prefer [ResponsiveInfo.fromSize] for tests.
  const ResponsiveInfo({
    required this.windowSize,
    required this.localSize,
    required this.sizeClass,
    this.breakpoints = ResponsiveBreakpoints.standard,
  });

  /// Builds a snapshot from a plain [size], without any widget tree.
  ///
  /// Handy for unit tests, golden tests and previews:
  /// ```dart
  /// final info = ResponsiveInfo.fromSize(const Size(700, 900));
  /// expect(info.isMedium, isTrue);
  /// ```
  factory ResponsiveInfo.fromSize(
    Size size, {
    Size? windowSize,
    ResponsiveBreakpoints breakpoints = ResponsiveBreakpoints.standard,
  }) {
    return ResponsiveInfo(
      windowSize: windowSize ?? size,
      localSize: size,
      sizeClass: breakpoints.sizeClassFor(size.width),
      breakpoints: breakpoints,
    );
  }

  /// Size of the whole app window.
  final Size windowSize;

  /// Size available to the local subtree.
  final Size localSize;

  /// Size class derived from the width of [localSize].
  final WindowSizeClass sizeClass;

  /// Breakpoints used to derive [sizeClass].
  final ResponsiveBreakpoints breakpoints;

  /// Available width of the local subtree in logical pixels.
  double get localWidth => localSize.width;

  /// Available height of the local subtree in logical pixels.
  double get localHeight => localSize.height;

  /// True when [sizeClass] is [WindowSizeClass.compact].
  bool get isCompact => sizeClass.isCompact;

  /// True when [sizeClass] is [WindowSizeClass.medium].
  bool get isMedium => sizeClass.isMedium;

  /// True when [sizeClass] is [WindowSizeClass.expanded].
  bool get isExpanded => sizeClass.isExpanded;

  /// True when [sizeClass] is [WindowSizeClass.large].
  bool get isLarge => sizeClass.isLarge;

  /// True when the width allows multi-column layouts (anything but compact).
  bool get isWide => sizeClass.isWide;

  /// True when [localSize] is wider than it is tall.
  bool get isLandscape => localSize.width > localSize.height;

  /// True when [localSize] is at least as tall as it is wide.
  bool get isPortrait => !isLandscape;

  /// Horizontal gutter for the local width; see [ResponsiveGutters.sideOf].
  double gutter({
    double compact = ResponsiveDefaults.compactGutter,
    double? contentMaxWidth,
  }) {
    return ResponsiveGutters.sideOf(
      localSize.width,
      gutter: compact,
      contentMaxWidth: contentMaxWidth ?? breakpoints.contentMaxWidth,
    );
  }

  /// Symmetric page padding for the local width; see
  /// [ResponsiveGutters.horizontal].
  EdgeInsets gutters({
    double compact = ResponsiveDefaults.compactGutter,
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

  /// Grid column count for the local width; see
  /// [ResponsiveBreakpoints.columnsFor].
  int columns({
    double minTileWidth = ResponsiveDefaults.minTileWidth,
    int minColumns = ResponsiveDefaults.minColumns,
    int maxColumns = ResponsiveDefaults.maxColumns,
    double spacing = 0.0,
    double padding = 0.0,
  }) {
    return breakpoints.columnsFor(
      localSize.width,
      minTileWidth: minTileWidth,
      minColumns: minColumns,
      maxColumns: maxColumns,
      spacing: spacing,
      padding: padding,
    );
  }

  /// Fluid value between [min] and [max] for the local width; see
  /// [ResponsiveFluid.clampedLerp]. [minWidth] defaults to 375 and [maxWidth]
  /// to `breakpoints.expandedMax`.
  double fluid({
    required double min,
    required double max,
    double? minWidth,
    double? maxWidth,
  }) {
    return ResponsiveFluid.clampedLerp(
      width: localSize.width,
      min: min,
      max: max,
      minWidth: minWidth ?? ResponsiveDefaults.designWidth,
      maxWidth: maxWidth ?? breakpoints.expandedMax,
    );
  }

  /// Picks the value for the active [sizeClass]; larger classes fall back to
  /// the nearest smaller one (see [WindowSizeClass.resolve]).
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
  String toString() => 'ResponsiveInfo(sizeClass: $sizeClass, '
      'localSize: $localSize, windowSize: $windowSize)';
}
