import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/breakpoints.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';

/// Centers a sliver child within a [CustomScrollView] and caps its maximum width
/// on wider screens (tablets/desktops) while behaving as a natural pass-through on phones.
///
/// Implemented via [SliverLayoutBuilder] so it adheres natively to Flutter's sliver protocol.
class ResponsiveSliverCenter extends StatelessWidget {
  const ResponsiveSliverCenter({
    super.key,
    required this.sliver,
    this.maxWidth = ResponsiveGutters.defaultContentMaxWidth,
    this.compactGutter = 16.0,
    this.breakpoints,
  });

  /// The sliver widget to constrain and center.
  final Widget sliver;

  /// The maximum content width budget. Defaults to 720dp.
  final double maxWidth;

  /// Minimum horizontal gutter on phone viewports. Defaults to 16dp.
  final double compactGutter;

  /// Optional custom breakpoints.
  final ResponsiveBreakpoints? breakpoints;

  /// Convenience constructor to wrap a normal box widget as a centered sliver.
  static Widget box({
    Key? key,
    required Widget child,
    double maxWidth = ResponsiveGutters.defaultContentMaxWidth,
    double compactGutter = 16.0,
    ResponsiveBreakpoints? breakpoints,
  }) {
    return ResponsiveSliverCenter(
      key: key,
      maxWidth: maxWidth,
      compactGutter: compactGutter,
      breakpoints: breakpoints,
      sliver: SliverToBoxAdapter(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    final activeBreakpoints = breakpoints ?? ResponsiveBreakpoints.standard;

    return SliverLayoutBuilder(
      builder: (sliverContext, constraints) {
        final localWidth = constraints.crossAxisExtent;
        final info = ResponsiveInfo(
          windowSize: windowSize,
          localSize: Size(localWidth, 0.0),
          sizeClass: activeBreakpoints.sizeClassFor(localWidth),
          breakpoints: activeBreakpoints,
        );

        final double side = ResponsiveGutters.sideOf(
          localWidth,
          gutter: compactGutter,
          contentMaxWidth: maxWidth,
        );

        return ResponsiveScope(
          info: info,
          child: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: side),
            sliver: sliver,
          ),
        );
      },
    );
  }
}
