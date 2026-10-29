import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';
import 'package:fluid_adaptive/src/math/gutters.dart';

/// Centres a sliver and caps its width inside a `CustomScrollView`.
///
/// It adds symmetric side padding (see `ResponsiveGutters`), so the scroll
/// view itself keeps the full width. Slivers inside see the reduced cross-axis
/// extent, which is what `ResponsiveSliverGrid` and `ResponsiveSliverBuilder`
/// measure. Vertical viewports only.
class ResponsiveSliverCenter extends StatelessWidget {
  /// Creates a centring wrapper for [sliver].
  const ResponsiveSliverCenter({
    super.key,
    required this.sliver,
    this.maxWidth = ResponsiveDefaults.contentMaxWidth,
    this.compactGutter = ResponsiveDefaults.compactGutter,
  });

  /// Wraps a box [child] in a `SliverToBoxAdapter`, then centres it.
  static Widget box({
    Key? key,
    required Widget child,
    double maxWidth = ResponsiveDefaults.contentMaxWidth,
    double compactGutter = ResponsiveDefaults.compactGutter,
  }) {
    return ResponsiveSliverCenter(
      key: key,
      maxWidth: maxWidth,
      compactGutter: compactGutter,
      sliver: SliverToBoxAdapter(child: child),
    );
  }

  /// The sliver to constrain and centre.
  final Widget sliver;

  /// Maximum content width in logical pixels (default 720).
  final double maxWidth;

  /// Minimum side gutter used when the viewport is narrower than [maxWidth]
  /// (default 16).
  final double compactGutter;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (sliverContext, constraints) {
        final double side = ResponsiveGutters.sideOf(
          constraints.crossAxisExtent,
          gutter: compactGutter,
          contentMaxWidth: maxWidth,
        );
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: side),
          sliver: sliver,
        );
      },
    );
  }
}
