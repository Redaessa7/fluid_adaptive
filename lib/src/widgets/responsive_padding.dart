import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// Wraps [child] with horizontal side gutters that automatically expand symmetrically
/// on wider screens (tablets/desktops) while keeping the exact [compactGutter] on phones.
class ResponsiveGutterPadding extends StatelessWidget {
  const ResponsiveGutterPadding({
    super.key,
    required this.child,
    this.compactGutter = 16.0,
    this.contentMaxWidth = ResponsiveGutters.defaultContentMaxWidth,
    this.vertical = 0.0,
  });

  /// The child widget to pad.
  final Widget child;

  /// The minimum horizontal gutter on phones. Defaults to 16dp.
  final double compactGutter;

  /// The maximum content width budget. Defaults to 720dp.
  final double contentMaxWidth;

  /// Optional vertical padding. Defaults to 0.0.
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final padding = ResponsiveGutters.horizontal(
          info.localSize.width,
          gutter: compactGutter,
          contentMaxWidth: contentMaxWidth,
          vertical: vertical,
        );

        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
