import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/gutters/gutters.dart';

/// Centers [child] and caps its maximum width so phone-designed content never
/// over-stretches across tablets, foldables, or desktop windows.
///
/// Below [maxWidth], it behaves as a natural pass-through with zero visual disruption.
/// Above [maxWidth], it constrains the child and centers it nicely.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveGutters.defaultContentMaxWidth,
    this.alignment = Alignment.topCenter,
    this.padding,
  });

  /// The widget to center and constrain.
  final Widget child;

  /// The maximum content width budget. Defaults to 720dp.
  final double maxWidth;

  /// Alignment within the available parent space. Defaults to [Alignment.topCenter].
  final AlignmentGeometry alignment;

  /// Optional padding applied around the constrained content box.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Align(
      alignment: alignment,
      child: content,
    );
  }
}
