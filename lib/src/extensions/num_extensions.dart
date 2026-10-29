import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';

/// Responsive helpers on [num]. Every method that needs the window or the
/// local width takes a [BuildContext].
extension ResponsiveNumExtension on num {
  /// This number on compact widths, or the given value for larger classes
  /// (falling back to the nearest smaller class).
  ///
  /// ```dart
  /// width: 200.responsive(context, medium: 320, large: 450)
  /// ```
  double responsive(
    BuildContext context, {
    double? medium,
    double? expanded,
    double? large,
  }) {
    return ResponsiveScope.of(context).value<double>(
      compact: toDouble(),
      medium: medium,
      expanded: expanded,
      large: large,
    );
  }

  /// Fluid value: this number at [minWidth] (default 375) growing linearly to
  /// [max] at [maxWidth] (default: the active `breakpoints.expandedMax`).
  /// Always within `[min, max]`; [min] defaults to this number.
  ///
  /// ```dart
  /// padding: EdgeInsets.all(16.fluid(context, max: 24))
  /// ```
  double fluid(
    BuildContext context, {
    required double max,
    double? min,
    double? minWidth,
    double? maxWidth,
  }) {
    return ResponsiveScope.of(context).fluid(
      min: min ?? toDouble(),
      max: max,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  }

  /// Scales this number with the available width relative to [designWidth]
  /// (default 375), keeping the factor within [minScale] .. [maxScale]
  /// (default 0.85 .. 1.35).
  double clampedW(
    BuildContext context, {
    double designWidth = ResponsiveDefaults.designWidth,
    double minScale = ResponsiveDefaults.minScale,
    double maxScale = ResponsiveDefaults.maxScale,
  }) {
    return _scaledBy(
      ResponsiveScope.of(context).localWidth,
      designWidth,
      minScale,
      maxScale,
    );
  }

  /// Scales this number with the available height relative to [designHeight]
  /// (default 812), keeping the factor within [minScale] .. [maxScale]
  /// (default 0.85 .. 1.35).
  double clampedH(
    BuildContext context, {
    double designHeight = ResponsiveDefaults.designHeight,
    double minScale = ResponsiveDefaults.minScale,
    double maxScale = ResponsiveDefaults.maxScale,
  }) {
    return _scaledBy(
      ResponsiveScope.of(context).localHeight,
      designHeight,
      minScale,
      maxScale,
    );
  }

  /// This number scaled by the user's system text scale, optionally capped at
  /// `this * maxScaleFactor`.
  ///
  /// Use it for **non-text** sizes that should grow with the user's text size
  /// (icon sizes, minimum tap-target heights, avatar sizes).
  ///
  /// Do **not** pass the result to `TextStyle.fontSize`: `Text` already applies
  /// the text scaler, so the text would be scaled twice. To cap text scaling
  /// use `MediaQuery.withClampedTextScaling` from Flutter.
  double textScaled(BuildContext context, {double? maxScaleFactor}) {
    assert(
      maxScaleFactor == null || maxScaleFactor > 0,
      'maxScaleFactor must be positive',
    );
    final double base = toDouble();
    final double scaled = MediaQuery.textScalerOf(context).scale(base);
    if (maxScaleFactor == null) return scaled;
    return math.min(scaled, base * maxScaleFactor);
  }

  /// This number as a percentage (0 - 100) of the available width.
  ///
  /// `50.widthPercent(context)` is half of the available width.
  double widthPercent(BuildContext context) {
    return ResponsiveScope.of(context).localWidth * (toDouble() / 100.0);
  }

  /// This number as a percentage (0 - 100) of the available height.
  double heightPercent(BuildContext context) {
    return ResponsiveScope.of(context).localHeight * (toDouble() / 100.0);
  }

  /// A horizontal [SizedBox] gap of this width.
  Widget get gapW => SizedBox(width: toDouble());

  /// A vertical [SizedBox] gap of this height.
  Widget get gapH => SizedBox(height: toDouble());

  double _scaledBy(
    double extent,
    double design,
    double minScale,
    double maxScale,
  ) {
    assert(design > 0, 'The design size must be positive');
    final double raw = extent / design;
    final double ratio =
        raw.isFinite ? math.min(math.max(raw, minScale), maxScale) : 1.0;
    return toDouble() * ratio;
  }
}
