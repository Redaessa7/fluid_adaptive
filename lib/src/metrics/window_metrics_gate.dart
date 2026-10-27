import 'package:flutter/widgets.dart';

/// Window metrics gate deciding when the app must rebuild on window changes.
///
/// Distinguishes between:
/// 1. Real window modifications (orientation flip, window resize, foldable hinge change)
///    -> Rebuilds immediately so layouts and typography update without lag.
/// 2. View insets jitter (keyboard show/hide, IME toggling)
///    -> Debounced so typing does not cause a rebuild storm or frame drops.
class RotationRebuildGate {
  /// Reference phone portrait design draft (e.g. iPhone standard 375x812).
  static const Size phonePortraitDesign = Size(375, 812);

  /// Reference phone landscape design draft with swapped axes.
  static const Size phoneLandscapeDesign = Size(812, 375);

  /// Threshold separating phones from tablets/desktop.
  static const double wideWindowThreshold = 600.0;

  /// Tolerance for floating-point jitter.
  static const double sameSizeEpsilon = 0.5;

  /// Tolerance for aspect ratio drift.
  static const double aspectEpsilon = 0.0005;

  /// Orientation-aware design draft size for [windowSize] in logical dp.
  ///
  /// For phones, returns the fixed reference draft.
  /// For wide windows (tablets/desktop), tracks the real window so scale factor remains ~1.0x.
  static Size designSizeFor(Size windowSize) {
    if (windowSize.width <= 0 || windowSize.height <= 0) {
      return phonePortraitDesign;
    }
    final bool landscape = windowSize.width > windowSize.height;
    if (windowSize.shortestSide > wideWindowThreshold) {
      if (!landscape) {
        return Size(windowSize.width, phonePortraitDesign.height);
      }
      return Size(windowSize.width, windowSize.height);
    }
    return landscape ? phoneLandscapeDesign : phonePortraitDesign;
  }

  /// Whether a window change requires an immediate rebuild rather than debouncing.
  ///
  /// Keyboard appearances leave the window size unchanged (only view insets change),
  /// correctly returning `false` here and avoiding frame drops.
  static bool needsImmediateRebuild(Size previousWindow, Size currentWindow) {
    if (previousWindow.width <= 0 ||
        previousWindow.height <= 0 ||
        currentWindow.width <= 0 ||
        currentWindow.height <= 0) {
      return true;
    }
    final bool wasLandscape = previousWindow.width > previousWindow.height;
    final bool isLandscape = currentWindow.width > currentWindow.height;
    if (wasLandscape != isLandscape) return true;

    if ((previousWindow.width - currentWindow.width).abs() > sameSizeEpsilon) {
      return true;
    }
    if ((previousWindow.height - currentWindow.height).abs() > sameSizeEpsilon) {
      return true;
    }

    final double previousAspect = previousWindow.width / previousWindow.height;
    final double currentAspect = currentWindow.width / currentWindow.height;
    return (previousAspect - currentAspect).abs() > aspectEpsilon;
  }
}
