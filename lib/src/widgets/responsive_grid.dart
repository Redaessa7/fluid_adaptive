import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/defaults.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/widgets/responsive_builder.dart';
import 'package:fluid_adaptive/src/widgets/responsive_sliver_builder.dart';

/// A [GridView] whose column count follows the available width so that every
/// tile is at least [minTileWidth] wide (padding and spacing included).
///
/// Use the `.builder` constructor for long lists and `.count` for a fixed list
/// of [children]. Built on `ResponsiveBuilder`, so it measures the space it is
/// given, not the screen.
class ResponsiveGridView extends StatelessWidget {
  /// Creates a grid that builds its tiles lazily.
  const ResponsiveGridView.builder({
    super.key,
    required int this.itemCount,
    required NullableIndexedWidgetBuilder this.itemBuilder,
    this.minTileWidth = ResponsiveDefaults.minTileWidth,
    this.minColumns = ResponsiveDefaults.minColumns,
    this.maxColumns = ResponsiveDefaults.maxColumns,
    this.crossAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.mainAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
  }) : children = null;

  /// Creates a grid from a fixed list of [children].
  const ResponsiveGridView.count({
    super.key,
    required List<Widget> this.children,
    this.minTileWidth = ResponsiveDefaults.minTileWidth,
    this.minColumns = ResponsiveDefaults.minColumns,
    this.maxColumns = ResponsiveDefaults.maxColumns,
    this.crossAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.mainAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : itemCount = null,
        itemBuilder = null;

  /// Number of tiles for the `.builder` constructor.
  final int? itemCount;

  /// Tile factory for the `.builder` constructor.
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// Tiles for the `.count` constructor.
  final List<Widget>? children;

  /// Minimum tile width along the grid's cross axis (default 170).
  final double minTileWidth;

  /// Lower bound for the column count (default 2).
  final int minColumns;

  /// Upper bound for the column count (default 8).
  final int maxColumns;

  /// Gap between tiles along the cross axis (default 12).
  final double crossAxisSpacing;

  /// Gap between tiles along the main axis (default 12).
  final double mainAxisSpacing;

  /// Width / height ratio of each tile; ignored when [mainAxisExtent] is set.
  final double childAspectRatio;

  /// Fixed tile extent along the main axis (use for text-heavy tiles).
  final double? mainAxisExtent;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Forwarded to the underlying [GridView].
  final ScrollPhysics? physics;

  /// Forwarded to the underlying [GridView].
  final bool shrinkWrap;

  /// Forwarded to the underlying [GridView].
  final ScrollController? controller;

  /// Scroll direction; a horizontal grid measures its height for columns.
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final EdgeInsets? resolved = padding?.resolve(
          Directionality.maybeOf(context) ?? TextDirection.ltr,
        );
        final bool vertical = scrollDirection == Axis.vertical;
        final gridDelegate = _gridDelegate(
          info,
          scrollDirection: scrollDirection,
          minTileWidth: minTileWidth,
          minColumns: minColumns,
          maxColumns: maxColumns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
          crossAxisPadding: resolved == null
              ? 0.0
              : (vertical ? resolved.horizontal : resolved.vertical),
        );

        final List<Widget>? fixed = children;
        if (fixed != null) {
          return GridView(
            controller: controller,
            padding: padding,
            physics: physics,
            shrinkWrap: shrinkWrap,
            scrollDirection: scrollDirection,
            gridDelegate: gridDelegate,
            children: fixed,
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

/// A [SliverGrid] whose column count follows the viewport width so that every
/// tile is at least [minTileWidth] wide (spacing included).
///
/// Measures the sliver's cross-axis extent, so wrapping it in a
/// `SliverPadding` or `ResponsiveSliverCenter` is accounted for. Vertical
/// viewports only.
class ResponsiveSliverGrid extends StatelessWidget {
  /// Creates a sliver grid that builds its tiles lazily.
  const ResponsiveSliverGrid.builder({
    super.key,
    required int this.itemCount,
    required NullableIndexedWidgetBuilder this.itemBuilder,
    this.minTileWidth = ResponsiveDefaults.minTileWidth,
    this.minColumns = ResponsiveDefaults.minColumns,
    this.maxColumns = ResponsiveDefaults.maxColumns,
    this.crossAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.mainAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  }) : delegate = null;

  /// Creates a sliver grid from a [SliverChildDelegate].
  const ResponsiveSliverGrid({
    super.key,
    required SliverChildDelegate this.delegate,
    this.minTileWidth = ResponsiveDefaults.minTileWidth,
    this.minColumns = ResponsiveDefaults.minColumns,
    this.maxColumns = ResponsiveDefaults.maxColumns,
    this.crossAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.mainAxisSpacing = ResponsiveDefaults.gridSpacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  })  : itemCount = null,
        itemBuilder = null;

  /// Child delegate for the default constructor.
  final SliverChildDelegate? delegate;

  /// Number of tiles for the `.builder` constructor.
  final int? itemCount;

  /// Tile factory for the `.builder` constructor.
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// Minimum tile width (default 170).
  final double minTileWidth;

  /// Lower bound for the column count (default 2).
  final int minColumns;

  /// Upper bound for the column count (default 8).
  final int maxColumns;

  /// Gap between tiles along the cross axis (default 12).
  final double crossAxisSpacing;

  /// Gap between tiles along the main axis (default 12).
  final double mainAxisSpacing;

  /// Width / height ratio of each tile; ignored when [mainAxisExtent] is set.
  final double childAspectRatio;

  /// Fixed tile extent along the main axis (use for text-heavy tiles).
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSliverBuilder(
      builder: (context, info) {
        final gridDelegate = _gridDelegate(
          info,
          scrollDirection: Axis.vertical,
          minTileWidth: minTileWidth,
          minColumns: minColumns,
          maxColumns: maxColumns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        );

        final SliverChildDelegate? custom = delegate;
        if (custom != null) {
          return SliverGrid(gridDelegate: gridDelegate, delegate: custom);
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

/// Shared by both grids: chooses the column count so every tile is at least
/// `minTileWidth` along the grid's cross axis (width when scrolling vertically,
/// height when scrolling horizontally).
SliverGridDelegateWithFixedCrossAxisCount _gridDelegate(
  ResponsiveInfo info, {
  required Axis scrollDirection,
  required double minTileWidth,
  required int minColumns,
  required int maxColumns,
  required double crossAxisSpacing,
  required double mainAxisSpacing,
  required double childAspectRatio,
  required double? mainAxisExtent,
  double crossAxisPadding = 0.0,
}) {
  final double crossExtent = scrollDirection == Axis.vertical
      ? info.localSize.width
      : info.localSize.height;
  final int columns = info.breakpoints.columnsFor(
    crossExtent,
    minTileWidth: minTileWidth,
    minColumns: minColumns,
    maxColumns: maxColumns,
    spacing: crossAxisSpacing,
    padding: crossAxisPadding,
  );
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisSpacing: mainAxisSpacing,
    childAspectRatio: childAspectRatio,
    mainAxisExtent: mainAxisExtent,
  );
}
