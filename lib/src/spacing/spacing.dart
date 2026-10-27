import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';

/// Centralized spacing, border radius, and fluid dimension calculations.
///
/// Unlike naive scaling that scales linearly to gigantic sizes on tablets,
/// [ResponsiveSpacing] uses stepped breakpoints or clamped interpolation
/// to give tablets breathing room while preserving phone ergonomics.
abstract final class ResponsiveSpacing {
  /// Resolves stepped spacing based on [width].
  static double spacingFor(
    double width, {
    double compact = 12.0,
    double medium = 16.0,
    double expanded = 24.0,
    double compactBreakpoint = 600.0,
    double mediumBreakpoint = 840.0,
  }) {
    if (width < compactBreakpoint) {
      return compact;
    }
    if (width < mediumBreakpoint) {
      return medium;
    }
    return expanded;
  }

  /// Resolves vertical gap between content sections.
  static double sectionGapFor(
    double width, {
    double multiplier = 1.5,
    double compact = 12.0,
    double medium = 16.0,
    double expanded = 24.0,
  }) {
    return spacingFor(
          width,
          compact: compact,
          medium: medium,
          expanded: expanded,
        ) *
        multiplier;
  }

  /// Dynamic corner radius that stays subtle on phones and softens gently on wide windows.
  static double radiusFor(
    double width, {
    double min = 12.0,
    double max = 28.0,
    double divisor = 40.0,
  }) {
    if (width <= 0) return min;
    return math.min(max, math.max(min, width / divisor));
  }

  /// Clamped fluid interpolation.
  ///
  /// Interpolates between [min] and [max] proportionally as [width]
  /// travels between [minWidth] and [maxWidth]. Clamped within `[min, max]`.
  ///
  /// Prevents the common bug in screen-util packages where tablets get
  /// inflated 3x sizes.
  static double fluid({
    required double width,
    required double min,
    required double max,
    double minWidth = 375.0,
    double maxWidth = 1200.0,
  }) {
    assert(minWidth < maxWidth, 'minWidth must be less than maxWidth');
    if (width <= minWidth) return min;
    if (width >= maxWidth) return max;
    final double t = (width - minWidth) / (maxWidth - minWidth);
    return min + (max - min) * t;
  }

  /// Generates full content page padding with horizontal gutters and vertical spacing.
  static EdgeInsets contentPaddingFor(
    double width, {
    double compactGutter = 16.0,
    double contentMaxWidth = ResponsiveGutters.defaultContentMaxWidth,
    double? vertical,
  }) {
    final double horizontal = ResponsiveGutters.sideOf(
      width,
      gutter: compactGutter,
      contentMaxWidth: contentMaxWidth,
    );
    final double vert = vertical ?? spacingFor(width);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vert);
  }
}
