import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';

/// Horizontal page gutters that keep content centred and readable.
///
/// - Below `contentMaxWidth`: exactly the phone gutter.
/// - Above it: `(width - contentMaxWidth) / 2` on each side, so the content
///   column stays `contentMaxWidth` wide and centred.
///
/// Prefer gutters for **scrollable** content (the scroll view keeps the full
/// width, so scrollbars and gestures stay at the screen edge). For a plain box
/// use `ResponsiveCenter`. Use one or the other for the same content, never both.
abstract final class ResponsiveGutters {
  /// Returns the horizontal gutter for [width]; never less than [gutter].
  ///
  /// Non-finite or non-positive widths return [gutter].
  static double sideOf(
    double width, {
    required double gutter,
    double contentMaxWidth = ResponsiveDefaults.contentMaxWidth,
  }) {
    if (!width.isFinite || width <= 0) return gutter;
    return math.max(gutter, (width - contentMaxWidth) / 2);
  }

  /// Returns symmetric [EdgeInsets] with the gutter for [width] on the left and
  /// right and [vertical] on top and bottom.
  static EdgeInsets horizontal(
    double width, {
    required double gutter,
    double contentMaxWidth = ResponsiveDefaults.contentMaxWidth,
    double vertical = 0.0,
  }) {
    final double side = sideOf(
      width,
      gutter: gutter,
      contentMaxWidth: contentMaxWidth,
    );
    return EdgeInsets.symmetric(horizontal: side, vertical: vertical);
  }
}
