import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Single mathematical source of truth for horizontal gutters and content centering.
///
/// Every screen and component can use [sideOf] so that horizontal padding
/// automatically adapts:
/// - Below [contentMaxWidth]: exact phone gutter ([gutter]).
/// - Above [contentMaxWidth]: expands symmetrically `(width - contentMaxWidth) / 2`
///   keeping content readable, centered, and aligned across all screens.
abstract final class ResponsiveGutters {
  /// Default centered-content maximum budget.
  static const double defaultContentMaxWidth = 720.0;

  /// Returns the horizontal gutter for [width].
  ///
  /// Guarantees at least [gutter] (typically 16dp on mobile),
  /// and expands dynamically when [width] exceeds [contentMaxWidth].
  static double sideOf(
    double width, {
    required double gutter,
    double contentMaxWidth = defaultContentMaxWidth,
  }) {
    if (width <= 0) return gutter;
    return math.max(gutter, (width - contentMaxWidth) / 2);
  }

  /// Returns [EdgeInsets] with horizontal side gutters calculated for [width].
  static EdgeInsets horizontal(
    double width, {
    required double gutter,
    double contentMaxWidth = defaultContentMaxWidth,
    double vertical = 0.0,
  }) {
    final side = sideOf(width, gutter: gutter, contentMaxWidth: contentMaxWidth);
    return EdgeInsets.symmetric(horizontal: side, vertical: vertical);
  }

  /// Returns [EdgeInsetsDirectional] with horizontal start/end gutters calculated for [width].
  static EdgeInsetsDirectional directional(
    double width, {
    required double gutter,
    double contentMaxWidth = defaultContentMaxWidth,
    double top = 0.0,
    double bottom = 0.0,
  }) {
    final side = sideOf(width, gutter: gutter, contentMaxWidth: contentMaxWidth);
    return EdgeInsetsDirectional.only(
      start: side,
      end: side,
      top: top,
      bottom: bottom,
    );
  }
}
