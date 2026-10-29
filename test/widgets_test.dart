import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

import 'test_utils.dart';

SliverGridDelegateWithFixedCrossAxisCount _sliverGridDelegate(
  WidgetTester tester,
) {
  final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
  return grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
}

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('reports the local size, not the window', (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      late ResponsiveInfo info;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 600,
                child: ResponsiveBuilder(
                  builder: (context, value) {
                    info = value;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(info.localSize, const Size(400, 600));
      expect(info.windowSize, const Size(1200, 800));
      expect(info.isCompact, isTrue);
    });

    testWidgets('context.responsive follows the nearest builder',
        (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      late double outside;
      late double inside;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (outer) {
              outside = outer.responsive.localWidth;
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 400,
                    height: 600,
                    child: ResponsiveBuilder(
                      builder: (context, _) {
                        inside = context.responsive.localWidth;
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(outside, 1200); // no builder above: the whole window
      expect(inside, 400); // inside the builder: the space it gets
    });

    testWidgets('explicit breakpoints win over ResponsiveConfig',
        (tester) async {
      setWindowSize(tester, const Size(700, 800));

      late WindowSizeClass sizeClass;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveConfig(
            breakpoints: const ResponsiveBreakpoints(compactMax: 800),
            child: child!,
          ),
          home: Scaffold(
            body: ResponsiveBuilder(
              breakpoints: const ResponsiveBreakpoints(compactMax: 650),
              builder: (context, info) {
                sizeClass = info.sizeClass;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(sizeClass, WindowSizeClass.medium); // 700 >= 650
    });
  });

  group('ResponsiveLayout', () {
    Future<void> pump(WidgetTester tester, double width) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: width,
              height: 800,
              child: ResponsiveLayout(
                compact: (_) => const Text('Compact View'),
                medium: (_) => const Text('Medium View'),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('selects the layout for the width', (tester) async {
      await pump(tester, 700);
      expect(find.text('Medium View'), findsOneWidget);
      expect(find.text('Compact View'), findsNothing);
    });

    testWidgets('falls back to the nearest smaller layout', (tester) async {
      await pump(tester, 1000); // expanded, but only compact + medium given
      expect(find.text('Medium View'), findsOneWidget);
    });
  });

  group('ResponsiveCenter', () {
    testWidgets('caps the maximum width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1200,
              height: 800,
              child: ResponsiveCenter(
                maxWidth: 600,
                child: Text('Centered Content'),
              ),
            ),
          ),
        ),
      );

      final box = tester.widget<ConstrainedBox>(
        find
            .ancestor(
              of: find.text('Centered Content'),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(box.constraints.maxWidth, 600.0);
    });

    test('rejects a non-positive maxWidth in debug', () {
      expect(
        () => ResponsiveCenter(maxWidth: 0, child: const SizedBox()),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ResponsiveRowColumn', () {
    Future<void> pump(WidgetTester tester, double width) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: width,
              height: 800,
              child: const ResponsiveRowColumn(
                spacing: 8,
                children: [
                  ResponsiveRowColumnItem(child: Text('Item 1')),
                  ResponsiveRowColumnItem(child: Text('Item 2')),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('is a column on compact widths', (tester) async {
      await pump(tester, 400);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('is a row on wide widths', (tester) async {
      await pump(tester, 800);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('isRow overrides the default decision', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 800,
              child: ResponsiveRowColumn(
                isRow: (info) => false,
                children: const [
                  ResponsiveRowColumnItem(child: Text('Item 1')),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });
  });

  group('ResponsiveGridView', () {
    testWidgets('keeps every tile at least minTileWidth wide', (tester) async {
      setWindowSize(tester, const Size(350, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGridView.builder(
              minTileWidth: 170,
              minColumns: 1,
              itemCount: 2,
              itemBuilder: (context, i) => SizedBox(key: ValueKey('tile$i')),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('tile0'))).width,
        greaterThanOrEqualTo(170),
      );
    });

    testWidgets('.count computes columns from the width', (tester) async {
      setWindowSize(tester, const Size(700, 800));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveGridView.count(
              children: [Text('a'), Text('b'), Text('c'), Text('d')],
            ),
          ),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      // (700 + 12) / (170 + 12) = 3.9 -> 3 columns
      expect(delegate.crossAxisCount, 3);
    });
  });

  group('ResponsiveSliverGrid', () {
    testWidgets('works inside a CustomScrollView', (tester) async {
      setWindowSize(tester, const Size(700, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverGrid.builder(
                  itemCount: 4,
                  itemBuilder: (context, i) => Text('t$i'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('t0'), findsOneWidget);
      expect(_sliverGridDelegate(tester).crossAxisCount, 3);
    });

    testWidgets('measures the width left by ResponsiveSliverCenter',
        (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  sliver: ResponsiveSliverGrid.builder(
                    itemCount: 4,
                    itemBuilder: (context, i) => Text('t$i'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 1200 - 2 * 240 = 720 usable -> (720 + 12) / 182 = 4.02 -> 4 columns
      expect(_sliverGridDelegate(tester).crossAxisCount, 4);
    });
  });

  group('Sliver builders', () {
    testWidgets('ResponsiveSliverCenter pads wide viewports', (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  maxWidth: 720,
                  compactGutter: 16,
                  sliver: SliverToBoxAdapter(child: Text('Sliver Content')),
                ),
              ],
            ),
          ),
        ),
      );

      final padding = tester.widget<SliverPadding>(
        find.byType(SliverPadding).first,
      );
      // (1200 - 720) / 2 = 240
      expect(padding.padding, const EdgeInsets.symmetric(horizontal: 240.0));
      expect(find.text('Sliver Content'), findsOneWidget);
    });

    testWidgets('ResponsiveSliverCenter.box wraps a box child',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter.box(child: const Text('Boxed')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Boxed'), findsOneWidget);
    });

    testWidgets('ResponsiveSliverBuilder exposes the viewport size',
        (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      late ResponsiveInfo info;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverBuilder(
                  builder: (context, value) {
                    info = value;
                    return const SliverToBoxAdapter(child: SizedBox(height: 10));
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(info.localWidth, 1200);
      expect(info.localHeight, greaterThan(0));
      expect(info.isLarge, isTrue);
    });
  });

  group('ResponsiveClassBuilder', () {
    testWidgets('rebuilds only when the size class changes', (tester) async {
      setWindowSize(tester, const Size(1300, 900));

      var builds = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveClassBuilder(
              builder: (context, sizeClass) {
                builds++;
                return Text(sizeClass.name);
              },
            ),
          ),
        ),
      );
      expect(builds, 1);
      expect(find.text('large'), findsOneWidget);

      // Still `large` (>= 1200): no rebuild.
      tester.view.physicalSize = const Size(1250, 900);
      await tester.pump();
      expect(builds, 1);

      // Crosses into `compact`: rebuilds once.
      tester.view.physicalSize = const Size(500, 900);
      await tester.pump();
      expect(builds, 2);
      expect(find.text('compact'), findsOneWidget);
    });
  });

  group('ResponsiveConfig', () {
    const custom = ResponsiveBreakpoints(
      compactMax: 800,
      mediumMax: 1000,
      expandedMax: 1400,
    );

    testWidgets('applies custom breakpoints app-wide', (tester) async {
      setWindowSize(tester, const Size(700, 900));

      late bool compact;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveConfig(breakpoints: custom, child: child!),
          home: Builder(
            builder: (context) {
              compact = context.isCompact; // 700 < 800
              return const SizedBox();
            },
          ),
        ),
      );

      expect(compact, isTrue);
    });

    testWidgets('num.fluid follows the configured expandedMax',
        (tester) async {
      setWindowSize(tester, const Size(1200, 800));

      late double value;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveConfig(
            breakpoints: const ResponsiveBreakpoints(expandedMax: 2000),
            child: child!,
          ),
          home: Builder(
            builder: (context) {
              value = 16.fluid(context, max: 32);
              return const SizedBox();
            },
          ),
        ),
      );

      // (1200 - 375) / (2000 - 375) = 0.5077 -> 16 + 16 * 0.5077
      expect(value, closeTo(24.12, 0.01));
    });
  });
}
