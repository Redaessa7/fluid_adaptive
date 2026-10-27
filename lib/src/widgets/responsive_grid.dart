import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';

/// An adaptive GridView that automatically computes its column count based on
/// available parent width and a minimum tile width ([minTileWidth]).
class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minTileWidth = 170.0,
    this.minColumns = 2,
    this.maxColumns = 8,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
  }) : children = null;

  const ResponsiveGridView.count({
    super.key,
    required this.children,
    this.minTileWidth = 170.0,
    this.minColumns = 2,
    this.maxColumns = 8,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : itemCount = null,
        itemBuilder = null;

  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final List<Widget>? children;

  /// Minimum width in logical dp desired for each grid item.
  final double minTileWidth;

  /// Minimum number of columns allowed.
  final int minColumns;

  /// Maximum number of columns allowed.
  final int maxColumns;

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final int columns = info.columns(
          minTileWidth: minTileWidth,
          minColumns: minColumns,
          maxColumns: maxColumns,
        );

        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        );

        if (children != null) {
          return GridView(
            controller: controller,
            padding: padding,
            physics: physics,
            shrinkWrap: shrinkWrap,
            scrollDirection: scrollDirection,
            gridDelegate: gridDelegate,
            children: children!,
          );
        }

        return GridView.builder(
          controller: controller,
          padding: padding,
          physics: physics,
          shrinkWrap: shrinkWrap,
          scrollDirection: scrollDirection,
          gridDelegate: gridDelegate,
          itemCount: itemCount,
          itemBuilder: itemBuilder!,
        );
      },
    );
  }
}

/// A SliverGrid that automatically determines column count based on available width.
class ResponsiveSliverGrid extends StatelessWidget {
  const ResponsiveSliverGrid.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minTileWidth = 170.0,
    this.minColumns = 2,
    this.maxColumns = 8,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  }) : delegate = null;

  const ResponsiveSliverGrid({
    super.key,
    required this.delegate,
    this.minTileWidth = 170.0,
    this.minColumns = 2,
    this.maxColumns = 8,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  })  : itemCount = null,
        itemBuilder = null;

  final SliverChildDelegate? delegate;
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final double minTileWidth;
  final int minColumns;
  final int maxColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final int columns = info.columns(
          minTileWidth: minTileWidth,
          minColumns: minColumns,
          maxColumns: maxColumns,
        );

        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        );

        if (delegate != null) {
          return SliverGrid(
            gridDelegate: gridDelegate,
            delegate: delegate!,
          );
        }

        return SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: itemCount,
          itemBuilder: itemBuilder!,
        );
      },
    );
  }
}
