import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';

/// Builds a subtree with local constraint awareness wrapped in a [ResponsiveScope].
///
/// Combines local parent constraints ([LayoutBuilder]) with the overall
/// application window metrics ([MediaQuery.sizeOf]) to derive a [ResponsiveInfo].
///
/// This ensures nested panels, sidebars, dialogues, and multi-window views adapt
/// according to the space they actually occupy, rather than the device hardware.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  /// Widget builder supplied with the active [BuildContext] (inside [ResponsiveScope])
  /// and the resolved [ResponsiveInfo].
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  /// Optional custom breakpoints. Defaults to [ResponsiveBreakpoints.standard].
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    final activeBreakpoints = breakpoints ?? ResponsiveBreakpoints.standard;

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final localWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : windowSize.width;
        final localHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : windowSize.height;

        final localSize = Size(localWidth, localHeight);
        final info = ResponsiveInfo(
          windowSize: windowSize,
          localSize: localSize,
          sizeClass: activeBreakpoints.sizeClassFor(localWidth),
          breakpoints: activeBreakpoints,
        );

        return ResponsiveScope(
          info: info,
          child: Builder(
            builder: (scopeContext) => builder(scopeContext, info),
          ),
        );
      },
    );
  }
}
