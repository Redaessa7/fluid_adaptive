import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';
import 'package:fluid_adaptive/src/spacing/responsive_tokens.dart';

/// Convenient extensions on [BuildContext] for responsive queries.
extension ResponsiveContextExtension on BuildContext {
  /// Active [ResponsiveInfo] for the current subtree.
  ///
  /// Works both inside and outside [ResponsiveBuilder]. Inside [ResponsiveBuilder],
  /// it respects local widget constraints; outside, it falls back to window metrics.
  ResponsiveInfo get responsive => ResponsiveScope.of(this);

  /// Standard responsive spacing tokens (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`).
  ///
  /// Automatically adapts values on wide screens without ballooning:
  /// ```dart
  /// SizedBox(height: context.spacing.md)
  /// ```
  ResponsiveSpacingTokens get spacing => ResponsiveSpacingTokens(context: this);

  /// Current [WindowSizeClass] for this context.
  WindowSizeClass get windowSizeClass => responsive.sizeClass;

  /// True when in phone / compact range (< 600dp).
  bool get isCompact => responsive.isCompact;

  /// True when in small tablet range (600dp - 839dp).
  bool get isMedium => responsive.isMedium;

  /// True when in large tablet range (840dp - 1199dp).
  bool get isExpanded => responsive.isExpanded;

  /// True when in desktop range (>= 1200dp).
  bool get isLarge => responsive.isLarge;

  /// True when wide enough for multi-column layouts (>= 600dp).
  bool get isWide => responsive.isWide;

  /// Semantic alias for phone viewports.
  bool get isPhone => responsive.isPhone;

  /// Semantic alias for tablet viewports.
  bool get isTablet => responsive.isTablet;

  /// Semantic alias for desktop viewports.
  bool get isDesktop => responsive.isDesktop;

  /// True if current width > height.
  bool get isLandscape => responsive.isLandscape;

  /// True if current height >= width.
  bool get isPortrait => responsive.isPortrait;

  /// Resolves a value corresponding to the current window size class.
  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    return responsive.value(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
    );
  }

  /// Calculates dynamic horizontal gutter for this context.
  double responsiveGutter({double compact = 16.0, double? contentMaxWidth}) {
    return responsive.gutter(compact: compact, contentMaxWidth: contentMaxWidth);
  }

  /// Returns fluid clamped sizing interpolated according to current width.
  double responsiveFluid({
    required double min,
    required double max,
    double? minWidth,
    double? maxWidth,
  }) {
    return responsive.fluid(
      min: min,
      max: max,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  }

  /// Automatically computes column count for grid layouts.
  int responsiveColumns({
    double minTileWidth = 170.0,
    int minColumns = 2,
    int maxColumns = 8,
  }) {
    return responsive.columns(
      minTileWidth: minTileWidth,
      minColumns: minColumns,
      maxColumns: maxColumns,
    );
  }

  /// Resolves standard stepped spacing based on current width.
  double responsiveSpacing({
    double compact = 12.0,
    double medium = 16.0,
    double expanded = 24.0,
  }) {
    return responsive.spacing(
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }
}
