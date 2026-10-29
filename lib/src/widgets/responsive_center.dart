import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';

/// Caps the width of [child] and centres it, so phone-designed content does
/// not stretch across tablets and desktop windows.
///
/// Below [maxWidth] it is a pass-through. It does not create a responsive
/// scope: `context.responsive` inside still describes the window unless you
/// add a `ResponsiveBuilder`. For scrollable content prefer gutters
/// (`ResponsiveInfo.gutters`) or `ResponsiveSliverCenter`, which keep the
/// scroll view full-width. Use one mechanism per screen, not both.
class ResponsiveCenter extends StatelessWidget {
  /// Creates a width-capping wrapper. [maxWidth] must be positive.
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveDefaults.contentMaxWidth,
    this.alignment = Alignment.topCenter,
    this.padding,
  }) : assert(maxWidth > 0, 'maxWidth must be positive');

  /// The content to constrain.
  final Widget child;

  /// Maximum content width in logical pixels (default 720).
  final double maxWidth;

  /// Where the capped content sits in the available space.
  final AlignmentGeometry alignment;

  /// Optional padding inside the capped box.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    final EdgeInsetsGeometry? resolvedPadding = padding;
    if (resolvedPadding != null) {
      content = Padding(padding: resolvedPadding, child: content);
    }

    return Align(alignment: alignment, child: content);
  }
}
