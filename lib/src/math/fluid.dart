import 'package:fluid_adaptive/src/core/defaults.dart';

/// Fluid (clamped linear) sizing.
///
/// Unlike blind scaling, the result never leaves `[min, max]`, so a value
/// cannot balloon on tablets or desktops.
abstract final class ResponsiveFluid {
  /// Interpolates between [min] and [max] as [width] travels from [minWidth]
  /// to [maxWidth]. Below [minWidth] the result is [min]; above [maxWidth] it
  /// is [max].
  ///
  /// A NaN [width] returns [min]. In debug builds [minWidth] must be smaller
  /// than [maxWidth]; in release builds a degenerate range returns [max] when
  /// [width] reaches it and [min] otherwise instead of dividing by zero.
  static double clampedLerp({
    required double width,
    required double min,
    required double max,
    double minWidth = ResponsiveDefaults.designWidth,
    double maxWidth = ResponsiveDefaults.fluidMaxWidth,
  }) {
    assert(minWidth < maxWidth, 'minWidth must be less than maxWidth');
    if (width.isNaN) return min;
    if (maxWidth <= minWidth) return width >= maxWidth ? max : min;
    if (width <= minWidth) return min;
    if (width >= maxWidth) return max;
    final double t = (width - minWidth) / (maxWidth - minWidth);
    return min + (max - min) * t;
  }
}
