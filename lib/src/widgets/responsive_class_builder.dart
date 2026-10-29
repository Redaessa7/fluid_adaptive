import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/core/responsive_config.dart';

/// Like `ResponsiveBuilder`, but rebuilds its subtree **only when the
/// [WindowSizeClass] changes**, not on every pixel of a window resize.
///
/// Use it around heavy screens on desktop / web, where the user can drag the
/// window edge and `LayoutBuilder` would otherwise rebuild the whole subtree
/// on every frame:
///
/// ```dart
/// ResponsiveClassBuilder(
///   builder: (context, sizeClass) =>
///       sizeClass.isCompact ? const PhoneShell() : const WideShell(),
/// )
/// ```
///
/// Trade-off: the builder receives only the size class. If you need the exact
/// width, use `ResponsiveBuilder` (or `ResponsiveLayout`) instead.
/// The subtree is still rebuilt whenever this widget's parent rebuilds, and
/// widgets inside keep reacting to their own inherited dependencies (Theme,
/// Localizations, ...).
class ResponsiveClassBuilder extends StatefulWidget {
  /// Creates a builder that rebuilds only when the size class changes.
  const ResponsiveClassBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  /// Builds the subtree for the given [WindowSizeClass].
  final Widget Function(BuildContext context, WindowSizeClass sizeClass)
      builder;

  /// Optional custom breakpoints. Defaults to the nearest [ResponsiveConfig],
  /// then [ResponsiveBreakpoints.standard].
  final ResponsiveBreakpoints? breakpoints;

  @override
  State<ResponsiveClassBuilder> createState() =>
      _ResponsiveClassBuilderState();
}

class _ResponsiveClassBuilderState extends State<ResponsiveClassBuilder> {
  _ClassBody? _cached;

  @override
  void didUpdateWidget(ResponsiveClassBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent rebuilt with a new builder/breakpoints: rebuild for real.
    _cached = null;
  }

  @override
  Widget build(BuildContext context) {
    final breakpoints =
        widget.breakpoints ?? ResponsiveConfig.breakpointsOf(context);

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(layoutContext).width;
        final sizeClass = breakpoints.sizeClassFor(width);

        final cached = _cached;
        // Returning the *same widget instance* lets Flutter skip the rebuild.
        if (cached != null && cached.sizeClass == sizeClass) return cached;
        return _cached = _ClassBody(sizeClass: sizeClass, builder: widget.builder);
      },
    );
  }
}

class _ClassBody extends StatelessWidget {
  const _ClassBody({required this.sizeClass, required this.builder});

  final WindowSizeClass sizeClass;
  final Widget Function(BuildContext context, WindowSizeClass sizeClass)
      builder;

  @override
  Widget build(BuildContext context) => builder(context, sizeClass);
}
