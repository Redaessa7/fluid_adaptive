import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/metrics/window_metrics_gate.dart';

/// Wraps your app root (or MaterialApp) to observe window metrics changes cleanly.
///
/// Automatically provides:
/// - Immediate rebuilds when screen orientation flips or resizable windows change.
/// - Debounced settling when software keyboard appears/disappears, preventing
///   frame drops and jitter storms.
class ResponsiveWindowGate extends StatefulWidget {
  const ResponsiveWindowGate({
    super.key,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 100),
    this.onWindowChanged,
  });

  /// The child widget tree (typically [MaterialApp] or root widget).
  final Widget child;

  /// Duration to debounce non-critical viewport changes (e.g. keyboard toggling).
  final Duration debounceDuration;

  /// Optional callback invoked whenever window metrics genuinely change.
  final void Function(Size newSize, bool isImmediate)? onWindowChanged;

  @override
  State<ResponsiveWindowGate> createState() => _ResponsiveWindowGateState();
}

class _ResponsiveWindowGateState extends State<ResponsiveWindowGate>
    with WidgetsBindingObserver {
  Timer? _metricsDebounce;
  Size? _lastWindowSize;
  late double _lastDesignWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastWindowSize = _windowLogicalSize();
    _lastDesignWidth = _designSize().width;
  }

  @override
  void dispose() {
    _metricsDebounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final Size? currentWindow = _windowLogicalSize();
    if (currentWindow == null) return;
    final Size? previousWindow = _lastWindowSize;
    _lastWindowSize = currentWindow;

    // 1. Genuine window change / orientation flip -> Rebuild immediately!
    if (previousWindow != null &&
        RotationRebuildGate.needsImmediateRebuild(previousWindow, currentWindow)) {
      _metricsDebounce?.cancel();
      _lastDesignWidth = RotationRebuildGate.designSizeFor(currentWindow).width;
      widget.onWindowChanged?.call(currentWindow, true);
      if (mounted) setState(() {});
      return;
    }

    // 2. View insets jitter / keyboard events -> Debounce to save frames!
    _metricsDebounce?.cancel();
    _metricsDebounce = Timer(widget.debounceDuration, () {
      if (!mounted) return;
      final double width = _designSize().width;
      if ((_lastDesignWidth - width).abs() > RotationRebuildGate.sameSizeEpsilon) {
        _lastDesignWidth = width;
        widget.onWindowChanged?.call(currentWindow, false);
        setState(() {});
      }
    });
  }

  static Size? _windowLogicalSize() {
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view == null || view.devicePixelRatio <= 0) return null;
    return view.physicalSize / view.devicePixelRatio;
  }

  static Size _designSize() {
    final Size? window = _windowLogicalSize();
    if (window == null) return RotationRebuildGate.phonePortraitDesign;
    return RotationRebuildGate.designSizeFor(window);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
