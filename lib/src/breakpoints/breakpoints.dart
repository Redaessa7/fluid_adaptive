import 'package:flutter/foundation.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';

/// Configurable breakpoints and sizing boundaries for adaptive layouts.
///
/// Decisions are always based on the available width (via [LayoutBuilder]
/// or [MediaQuery]), enabling components to respond correctly inside split screens,
/// modals, foldables, and desktop windows.
@immutable
class ResponsiveBreakpoints {
  /// Creates a custom set of breakpoints.
  const ResponsiveBreakpoints({
    this.compactMax = 600.0,
    this.mediumMax = 840.0,
    this.expandedMax = 1200.0,
    this.contentMaxWidth = 720.0,
  }) : assert(compactMax > 0 && mediumMax > compactMax && expandedMax > mediumMax,
            'Breakpoints must be strictly increasing');

  /// Standard industry-standard Material 3 breakpoints.
  static const ResponsiveBreakpoints standard = ResponsiveBreakpoints();

  /// Phones: single-column layouts, default phone rhythm.
  final double compactMax;

  /// Small tablets / unfolded foldables / landscape phones: 2-column content.
  final double mediumMax;

  /// Large tablets / desktop windows.
  final double expandedMax;

  /// Shared centered-content budget, so gutters across screens line up uniformly.
  final double contentMaxWidth;

  /// Classifies [width] into a [WindowSizeClass].
  WindowSizeClass sizeClassFor(double width) {
    if (width < compactMax) {
      return WindowSizeClass.compact;
    }
    if (width < mediumMax) {
      return WindowSizeClass.medium;
    }
    if (width < expandedMax) {
      return WindowSizeClass.expanded;
    }
    return WindowSizeClass.large;
  }

  /// Whether [width] qualifies as a wide viewport (tablet, foldable, desktop).
  bool isWide(double width) => width >= compactMax;

  /// Computes the side gutter for [width]: uses [compactGutter] below [contentMaxWidth],
  /// and expands symmetrically above it so content stays centered.
  double guttersFor(double width, {required double compactGutter}) =>
      ResponsiveGutters.sideOf(
        width,
        gutter: compactGutter,
        contentMaxWidth: contentMaxWidth,
      );

  /// Automatically computes column count for a grid whose tiles want at least
  /// [minTileWidth] logical dp each, bounded between [minColumns] and [maxColumns].
  int columnsFor(
    double width, {
    double minTileWidth = 170.0,
    int minColumns = 2,
    int maxColumns = 8,
  }) {
    if (width <= 0 || minTileWidth <= 0) return minColumns;
    final int raw = (width / minTileWidth).floor();
    return raw.clamp(minColumns, maxColumns);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveBreakpoints &&
          compactMax == other.compactMax &&
          mediumMax == other.mediumMax &&
          expandedMax == other.expandedMax &&
          contentMaxWidth == other.contentMaxWidth;

  @override
  int get hashCode =>
      Object.hash(compactMax, mediumMax, expandedMax, contentMaxWidth);
}
