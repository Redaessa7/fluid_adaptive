import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';
import 'package:fluid_adaptive/src/spacing/spacing.dart';

/// Convenient responsive and fluid scaling extensions on [num].
///
/// Gives the speed and simplicity of `ScreenUtil` without its tablet-breaking bugs:
/// - Provides intelligent clamped scaling (`clampedW`, `clampedH`).
/// - Provides fluid interpolation with hard bounds (`fluid`).
/// - Provides screen-class selection (`responsive`).
/// - Provides accessibility-safe typography (`sp`).
/// - Provides quick responsive spacing widgets (`gapW`, `gapH`).
extension ResponsiveNumExtension on num {
  /// Resolves this number across screen classes.
  ///
  /// ```dart
  /// // 200 on phone, 320 on tablet, 450 on desktop:
  /// width: 200.responsive(context, tablet: 320, desktop: 450)
  /// ```
  double responsive(
    BuildContext context, {
    double? tablet,
    double? desktop,
    double? large,
  }) {
    final info = ResponsiveScope.of(context);
    final val = toDouble();
    return info.value<double>(
      compact: val,
      medium: tablet ?? val,
      expanded: tablet ?? val,
      large: large ?? desktop ?? tablet ?? val,
    );
  }

  /// Clamped fluid scaling.
  ///
  /// Smoothly interpolates starting from this number at [minWidth] (default 375)
  /// up to [max] at [maxWidth] (default 1200).
  ///
  /// Unlike naive multipliers, the result is **strictly clamped** and will never
  /// blow up to oversized dimensions on tablets or desktops.
  ///
  /// ```dart
  /// // Scales gently from 16 to 24 on large screens:
  /// padding: EdgeInsets.all(16.fluid(context, max: 24))
  /// ```
  double fluid(
    BuildContext context, {
    required double max,
    double? min,
    double minWidth = 375.0,
    double maxWidth = 1200.0,
  }) {
    final info = ResponsiveScope.of(context);
    return ResponsiveSpacing.fluid(
      width: info.localWidth,
      min: min ?? toDouble(),
      max: max,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  }

  /// Proportional width scaling with safety bounds (Clamped Width).
  ///
  /// Scales this dimension proportionally against a [designWidth] (default 375dp),
  /// but clamps the resulting multiplier between [minScale] (default 0.8x)
  /// and [maxScale] (default 1.35x).
  ///
  /// This prevents the infamous "giant button on tablet" bug seen in ScreenUtil.
  double clampedW(
    BuildContext context, {
    double designWidth = 375.0,
    double minScale = 0.85,
    double maxScale = 1.35,
  }) {
    final info = ResponsiveScope.of(context);
    final ratio = info.localWidth / designWidth;
    final clampedRatio = ratio.clamp(minScale, maxScale);
    return toDouble() * clampedRatio;
  }

  /// Proportional height scaling with safety bounds (Clamped Height).
  ///
  /// Scales against a [designHeight] (default 812dp) with clamped boundaries.
  double clampedH(
    BuildContext context, {
    double designHeight = 812.0,
    double minScale = 0.85,
    double maxScale = 1.35,
  }) {
    final info = ResponsiveScope.of(context);
    final ratio = info.localHeight / designHeight;
    final clampedRatio = ratio.clamp(minScale, maxScale);
    return toDouble() * clampedRatio;
  }

  /// Scaled font size respecting the user's OS [TextScaler] with a safety ceiling.
  ///
  /// Guarantees that accessibility preferences are honored, but applies a safety clamp
  /// (default up to [maxScaleFactor] = 1.5x) so text never overflows out of buttons or cards.
  double sp(
    BuildContext context, {
    double maxScaleFactor = 1.5,
    double minScaleFactor = 0.8,
  }) {
    final scaler = MediaQuery.textScalerOf(context);
    final baseSize = toDouble();
    final scaled = scaler.scale(baseSize);
    return scaled.clamp(baseSize * minScaleFactor, baseSize * maxScaleFactor);
  }

  /// Creates a horizontal [SizedBox] gap with this width.
  Widget get gapW => SizedBox(width: toDouble());

  /// Creates a vertical [SizedBox] gap with this height.
  Widget get gapH => SizedBox(height: toDouble());

  /// Creates a horizontal [SizedBox] whose width adapts to the screen.
  Widget responsiveGapW(
    BuildContext context, {
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(width: responsive(context, tablet: tablet, desktop: desktop));
  }

  /// Creates a vertical [SizedBox] whose height adapts to the screen.
  Widget responsiveGapH(
    BuildContext context, {
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(height: responsive(context, tablet: tablet, desktop: desktop));
  }

  /// Percentage of the available local width (0.0 to 100.0).
  ///
  /// `50.w(context)` equals 50% of the available width.
  double w(BuildContext context) {
    final info = ResponsiveScope.of(context);
    return info.localWidth * (toDouble() / 100.0);
  }

  /// Percentage of the available local height (0.0 to 100.0).
  ///
  /// `30.h(context)` equals 30% of the available height.
  double h(BuildContext context) {
    final info = ResponsiveScope.of(context);
    return info.localHeight * (toDouble() / 100.0);
  }
}
