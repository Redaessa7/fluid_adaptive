import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  group('ResponsiveBreakpoints', () {
    const breakpoints = ResponsiveBreakpoints.standard;

    test('classifies window size classes correctly', () {
      expect(breakpoints.sizeClassFor(360), WindowSizeClass.compact);
      expect(breakpoints.sizeClassFor(599), WindowSizeClass.compact);
      expect(breakpoints.sizeClassFor(600), WindowSizeClass.medium);
      expect(breakpoints.sizeClassFor(839), WindowSizeClass.medium);
      expect(breakpoints.sizeClassFor(840), WindowSizeClass.expanded);
      expect(breakpoints.sizeClassFor(1199), WindowSizeClass.expanded);
      expect(breakpoints.sizeClassFor(1200), WindowSizeClass.large);
    });

    test('isWide signals >= 600dp', () {
      expect(breakpoints.isWide(375), isFalse);
      expect(breakpoints.isWide(600), isTrue);
      expect(breakpoints.isWide(1024), isTrue);
    });

    test('computes columns appropriately', () {
      expect(breakpoints.columnsFor(360, minTileWidth: 170), 2);
      expect(breakpoints.columnsFor(600, minTileWidth: 170), 3);
      expect(breakpoints.columnsFor(1024, minTileWidth: 170), 6);
      expect(breakpoints.columnsFor(2000, minTileWidth: 170, maxColumns: 6), 6);
    });
  });

  group('ResponsiveGutters', () {
    test('uses compact gutter below contentMaxWidth', () {
      // 375dp phone, gutter 16, contentMaxWidth 720
      final gutter = ResponsiveGutters.sideOf(375, gutter: 16, contentMaxWidth: 720);
      expect(gutter, 16.0);
    });

    test('centers content symmetrically above contentMaxWidth', () {
      // 1000dp tablet, gutter 16, contentMaxWidth 720 -> (1000 - 720) / 2 = 140
      final gutter = ResponsiveGutters.sideOf(1000, gutter: 16, contentMaxWidth: 720);
      expect(gutter, 140.0);
    });
  });

  group('ResponsiveSpacing & Fluid', () {
    test('stepped spacing matches breakpoints', () {
      expect(ResponsiveSpacing.spacingFor(375), 12.0);
      expect(ResponsiveSpacing.spacingFor(700), 16.0);
      expect(ResponsiveSpacing.spacingFor(1000), 24.0);
    });

    test('fluid clamped interpolation scales smoothly within bounds', () {
      // min: 14 at 375, max: 20 at 1200
      expect(ResponsiveSpacing.fluid(width: 300, min: 14, max: 20, minWidth: 375, maxWidth: 1200), 14.0);
      expect(ResponsiveSpacing.fluid(width: 375, min: 14, max: 20, minWidth: 375, maxWidth: 1200), 14.0);
      expect(ResponsiveSpacing.fluid(width: 1200, min: 14, max: 20, minWidth: 375, maxWidth: 1200), 20.0);
      expect(ResponsiveSpacing.fluid(width: 1500, min: 14, max: 20, minWidth: 375, maxWidth: 1200), 20.0);

      // Mid-point roughly
      final mid = ResponsiveSpacing.fluid(width: 787.5, min: 14, max: 20, minWidth: 375, maxWidth: 1200);
      expect(mid, closeTo(17.0, 0.01));
    });
  });

  group('RotationRebuildGate', () {
    test('detects orientation flip immediately', () {
      const portrait = Size(375, 812);
      const landscape = Size(812, 375);
      expect(RotationRebuildGate.needsImmediateRebuild(portrait, landscape), isTrue);
    });

    test('does not rebuild immediately on identical window size (keyboard)', () {
      const window1 = Size(375, 812);
      const window2 = Size(375, 812);
      expect(RotationRebuildGate.needsImmediateRebuild(window1, window2), isFalse);
    });

    test('tracks real window on wide screens for design size', () {
      const tablet = Size(1024, 768);
      final design = RotationRebuildGate.designSizeFor(tablet);
      expect(design, const Size(1024, 768));
    });
  });

  group('Widgets', () {
    testWidgets('ResponsiveBuilder supplies valid info to subtree', (tester) async {
      late ResponsiveInfo capturedInfo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 600,
                child: ResponsiveBuilder(
                  builder: (context, info) {
                    capturedInfo = info;
                    return Text('Width: ${info.localWidth}');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Width: 400.0'), findsOneWidget);
      expect(capturedInfo.isCompact, isTrue);
      expect(capturedInfo.isWide, isFalse);
    });

    testWidgets('ResponsiveLayout selects correct layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 700,
              height: 800,
              child: ResponsiveLayout(
                compact: (_) => const Text('Compact View'),
                medium: (_) => const Text('Medium View'),
                expanded: (_) => const Text('Expanded View'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Medium View'), findsOneWidget);
      expect(find.text('Compact View'), findsNothing);
    });

    testWidgets('ResponsiveCenter caps maximum width', (tester) async {
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

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.ancestor(
          of: find.text('Centered Content'),
          matching: find.byType(ConstrainedBox),
        ).first,
      );

      expect(constrainedBox.constraints.maxWidth, 600.0);
    });

    testWidgets('ResponsiveRowColumn switches axis correctly', (tester) async {
      // 1. In compact width (< 600), should render Column
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: ResponsiveRowColumn(
                children: const [
                  ResponsiveRowColumnItem(child: Text('Item 1')),
                  ResponsiveRowColumnItem(child: Text('Item 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);

      // 2. In wide width (>= 600), should render Row
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 800,
              child: ResponsiveRowColumn(
                children: const [
                  ResponsiveRowColumnItem(child: Text('Item 1')),
                  ResponsiveRowColumnItem(child: Text('Item 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('BuildContext extension responsiveValue works seamlessly', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveBuilder(
              builder: (context, _) {
                final text = context.responsiveValue<String>(
                  compact: 'Phone',
                  medium: 'Tablet',
                  expanded: 'Desktop',
                );
                return Text(text);
              },
            ),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('ResponsiveNumExtension calculates clamped and fluid values safely', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late double responsiveVal;
      late double fluidVal;
      late double clampedWVal;
      late double spVal;
      late double spacingMd;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveBuilder(
              builder: (context, _) {
                responsiveVal = 100.responsive(context, tablet: 200, desktop: 300);
                fluidVal = 16.fluid(context, max: 24);
                clampedWVal = 100.clampedW(context);
                spVal = 16.sp(context);
                spacingMd = context.spacing.md;
                return Column(
                  children: [
                    16.gapH,
                    const Text('Test Content'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // On 1200 width (Desktop/Expanded):
      expect(responsiveVal, 300.0);
      expect(fluidVal, 24.0);
      // ClampedW: 100 * (1200/375 = 3.2 clamped to 1.35) -> 135.0 (NEVER 320!)
      expect(clampedWVal, 135.0);
      expect(spVal, 16.0);
      expect(spacingMd, 20.0); // Adaptive spacing on wide screen
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('ResponsiveSliverCenter pads content horizontally on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  maxWidth: 720,
                  compactGutter: 16,
                  sliver: SliverToBoxAdapter(
                    child: Text('Sliver Content'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final sliverPadding = tester.widget<SliverPadding>(
        find.byType(SliverPadding).first,
      );

      // Width is 1200, contentMaxWidth is 720 -> (1200 - 720) / 2 = 240
      expect(sliverPadding.padding, const EdgeInsets.symmetric(horizontal: 240.0));
      expect(find.text('Sliver Content'), findsOneWidget);
    });
  });
}
