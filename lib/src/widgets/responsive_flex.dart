import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// Item configuration for a child within [ResponsiveRowColumn].
class ResponsiveRowColumnItem {
  const ResponsiveRowColumnItem({
    required this.child,
    this.rowFlex = 1,
    this.columnFlex = 0,
    this.rowFit = FlexFit.tight,
    this.columnFit = FlexFit.loose,
    this.padding,
  });

  /// The widget content.
  final Widget child;

  /// Flex value when rendered in a [Row]. If > 0, child is wrapped in [Flexible] / [Expanded].
  final int rowFlex;

  /// Flex value when rendered in a [Column]. If > 0, child is wrapped in [Flexible] / [Expanded].
  final int columnFlex;

  /// FlexFit when rendered in a [Row].
  final FlexFit rowFit;

  /// FlexFit when rendered in a [Column].
  final FlexFit columnFit;

  /// Optional padding around the item.
  final EdgeInsetsGeometry? padding;
}

/// Dynamically renders children inside a [Row] or a [Column] based on responsive conditions.
///
/// Automatically switches between single-column phone layout and multi-column tablet layout.
class ResponsiveRowColumn extends StatelessWidget {
  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.isRow,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
  });

  /// The list of items.
  final List<ResponsiveRowColumnItem> children;

  /// Predicate deciding if layout should be a [Row]. Defaults to [info.isWide].
  final bool Function(ResponsiveInfo info)? isRow;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  /// Optional spacing between items.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final useRow = isRow != null ? isRow!(info) : info.isWide;

        final List<Widget> widgets = [];
        for (int i = 0; i < children.length; i++) {
          final item = children[i];
          Widget widget = item.child;

          if (item.padding != null) {
            widget = Padding(padding: item.padding!, child: widget);
          }

          final flex = useRow ? item.rowFlex : item.columnFlex;
          final fit = useRow ? item.rowFit : item.columnFit;

          if (flex > 0) {
            widget = Flexible(flex: flex, fit: fit, child: widget);
          }

          widgets.add(widget);

          if (spacing > 0 && i < children.length - 1) {
            widgets.add(
              useRow ? SizedBox(width: spacing) : SizedBox(height: spacing),
            );
          }
        }

        if (useRow) {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: widgets,
          );
        } else {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: widgets,
          );
        }
      },
    );
  }
}
