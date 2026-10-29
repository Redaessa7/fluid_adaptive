import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/core/responsive_config.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';

/// Sliver counterpart of `ResponsiveBuilder`: builds a sliver from the
/// viewport space it gets.
///
/// The local width is the sliver's cross-axis extent (so ancestors such as
/// `SliverPadding` are accounted for) and the local height is the viewport's
/// main-axis extent. Designed for vertically scrolling viewports.
class ResponsiveSliverBuilder extends StatelessWidget {
  /// Creates a sliver builder.
  const ResponsiveSliverBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  /// Builds the sliver. The context is inside the new [ResponsiveScope].
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  /// Breakpoints to use; defaults to the nearest `ResponsiveConfig`, then
  /// [ResponsiveBreakpoints.standard].
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    final active = breakpoints ?? ResponsiveConfig.breakpointsOf(context);

    return SliverLayoutBuilder(
      builder: (sliverContext, constraints) {
        final bool vertical = constraints.axis == Axis.vertical;
        final double cross = constraints.crossAxisExtent;
        final double main = constraints.viewportMainAxisExtent.isFinite
            ? constraints.viewportMainAxisExtent
            : (vertical ? windowSize.height : windowSize.width);
        final Size localSize = vertical ? Size(cross, main) : Size(main, cross);

        final info = ResponsiveInfo(
          windowSize: windowSize,
          localSize: localSize,
          sizeClass: active.sizeClassFor(localSize.width),
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
