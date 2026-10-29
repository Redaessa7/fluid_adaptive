import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// One child of a [ResponsiveRowColumn] with separate flex settings for the row
/// and the column layout.
@immutable
final class ResponsiveRowColumnItem {
  /// Creates an item.
  const ResponsiveRowColumnItem({
    required this.child,
    this.rowFlex = 1,
    this.columnFlex = 0,
    this.rowFit = FlexFit.tight,
    this.columnFit = FlexFit.loose,
    this.padding,
  });

  /// The content.
  final Widget child;

  /// Flex factor when laid out in a [Row]; a value above 0 wraps the child in
  /// a [Flexible].
  final int rowFlex;

  /// Flex factor when laid out in a [Column]; a value above 0 wraps the child
  /// in a [Flexible]. Needs a bounded height.
  final int columnFlex;

  /// Flex fit when laid out in a [Row].
  final FlexFit rowFit;

  /// Flex fit when laid out in a [Column].
  final FlexFit columnFit;

  /// Optional padding around the child.
  final EdgeInsetsGeometry? padding;
}

/// Lays children out in a [Row] when there is room and in a [Column] when
/// there is not.
///
/// By default it uses a row from [WindowSizeClass.medium] up; override [isRow]
/// to decide differently.
class ResponsiveRowColumn extends StatelessWidget {
  /// Creates a row/column switch.
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

  /// The items, in order.
  final List<ResponsiveRowColumnItem> children;

  /// Decides whether to use a [Row]; defaults to [ResponsiveInfo.isWide].
  final bool Function(ResponsiveInfo info)? isRow;

  /// Forwarded to the underlying [Row] or [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// Forwarded to the underlying [Row] or [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// Forwarded to the underlying [Row] or [Column].
  final MainAxisSize mainAxisSize;

  /// Forwarded to the underlying [Row] or [Column].
  final TextDirection? textDirection;

  /// Forwarded to the underlying [Row] or [Column].
  final VerticalDirection verticalDirection;

  /// Forwarded to the underlying [Row] or [Column].
  final TextBaseline? textBaseline;

  /// Gap between consecutive items, horizontal in a row, vertical in a column.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final bool useRow = isRow?.call(info) ?? info.isWide;

        final List<Widget> widgets = <Widget>[];
        for (int i = 0; i < children.length; i++) {
          final ResponsiveRowColumnItem item = children[i];
          Widget widget = item.child;

          final EdgeInsetsGeometry? itemPadding = item.padding;
          if (itemPadding != null) {
            widget = Padding(padding: itemPadding, child: widget);
          }

          final int flex = useRow ? item.rowFlex : item.columnFlex;
          final FlexFit fit = useRow ? item.rowFit : item.columnFit;
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
        }
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: widgets,
        );
      },
    );
  }
}
