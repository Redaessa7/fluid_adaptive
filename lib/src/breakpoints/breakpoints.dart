import 'package:flutter/foundation.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';

/// Configurable breakpoints for adaptive layouts.
///
/// Decisions are always based on the **available width** (from a
/// `LayoutBuilder` or `MediaQuery`), so components respond correctly inside
/// split screens, dialogs, foldables and desktop windows.
@immutable
final class ResponsiveBreakpoints {
  /// Creates a set of breakpoints. Values must be strictly increasing.
  const ResponsiveBreakpoints({
    this.compactMax = 600.0,
    this.mediumMax = 840.0,
    this.expandedMax = 1200.0,
    this.contentMaxWidth = ResponsiveDefaults.contentMaxWidth,
  }) : assert(
          compactMax > 0 && mediumMax > compactMax && expandedMax > mediumMax,
          'Breakpoints must be strictly increasing',
        );

  /// The standard Material 3 breakpoints (600 / 840 / 1200).
  static const ResponsiveBreakpoints standard = ResponsiveBreakpoints();

  /// Widths below this value are [WindowSizeClass.compact].
  final double compactMax;

  /// Widths below this value (and at least [compactMax]) are
  /// [WindowSizeClass.medium].
  final double mediumMax;

  /// Widths below this value (and at least [mediumMax]) are
  /// [WindowSizeClass.expanded]; anything wider is [WindowSizeClass.large].
  final double expandedMax;

  /// Default content width budget used by gutters, so page padding lines up
  /// across screens.
  final double contentMaxWidth;

  /// Classifies [width] into a [WindowSizeClass]. NaN counts as compact.
  WindowSizeClass sizeClassFor(double width) {
    if (width.isNaN || width < compactMax) {
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

  /// Number of grid columns for [width] so that every tile is at least
  /// [minTileWidth] wide, bounded by [minColumns] and [maxColumns].
  ///
  /// Pass [spacing] (gap between tiles) and [padding] (total padding along the
  /// same axis) for exact results. Never throws on odd input: inconsistent
  /// bounds are normalised and non-finite or non-positive widths return the
  /// minimum column count.
  int columnsFor(
    double width, {
    double minTileWidth = ResponsiveDefaults.minTileWidth,
    int minColumns = ResponsiveDefaults.minColumns,
    int maxColumns = ResponsiveDefaults.maxColumns,
    double spacing = 0.0,
    double padding = 0.0,
  }) {
    final int lo = minColumns < 1 ? 1 : minColumns;
    final int hi = maxColumns < lo ? lo : maxColumns;
    final double gap = spacing < 0 ? 0.0 : spacing;
    final double usable = width - padding;
    if (!usable.isFinite ||
        usable <= 0 ||
        !minTileWidth.isFinite ||
        minTileWidth <= 0) {
      return lo;
    }
    final int raw = ((usable + gap) / (minTileWidth + gap)).floor();
    return raw.clamp(lo, hi);
  }

  /// Returns a copy with the given fields replaced.
  ResponsiveBreakpoints copyWith({
    double? compactMax,
    double? mediumMax,
    double? expandedMax,
    double? contentMaxWidth,
  }) {
    return ResponsiveBreakpoints(
      compactMax: compactMax ?? this.compactMax,
      mediumMax: mediumMax ?? this.mediumMax,
      expandedMax: expandedMax ?? this.expandedMax,
      contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    );
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

  @override
  String toString() => 'ResponsiveBreakpoints(compactMax: $compactMax, '
      'mediumMax: $mediumMax, expandedMax: $expandedMax, '
      'contentMaxWidth: $contentMaxWidth)';
}
