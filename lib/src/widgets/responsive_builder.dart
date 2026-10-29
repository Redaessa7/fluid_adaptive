import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/core/responsive_config.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';

/// Builds a subtree from the space it actually gets.
///
/// Combines the parent's constraints (via `LayoutBuilder`) with the window
/// size into a [ResponsiveInfo] and exposes it through a [ResponsiveScope], so
/// `context.responsive` inside the subtree describes the local area. Nested
/// panels, dialogs and sidebars therefore adapt to their own width.
///
/// When the incoming constraints are unbounded the window size is used for
/// that axis. Because it is built on `LayoutBuilder`, it cannot be placed under
/// `IntrinsicHeight` or `IntrinsicWidth`. It rebuilds its subtree whenever the
/// constraints change; use `ResponsiveClassBuilder` to rebuild only when the
/// size class changes.
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a builder.
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  /// Builds the subtree. The context is inside the new [ResponsiveScope].
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  /// Breakpoints to use; defaults to the nearest `ResponsiveConfig`, then
  /// [ResponsiveBreakpoints.standard].
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    final active = breakpoints ?? ResponsiveConfig.breakpointsOf(context);

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final double localWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : windowSize.width;
        final double localHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : windowSize.height;

        final info = ResponsiveInfo(
          windowSize: windowSize,
          localSize: Size(localWidth, localHeight),
          sizeClass: active.sizeClassFor(localWidth),
          breakpoints: active,
        );

        return ResponsiveScope(
          info: info,
          child: Builder(builder: (scopeContext) => builder(scopeContext, info)),
        );
      },
    );
  }
}
