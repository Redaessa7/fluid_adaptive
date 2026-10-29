import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

import 'test_utils.dart';

/// Pumps an app with a window of [window] and runs [read] while building.
Future<void> _pumpWith(
  WidgetTester tester,
  Size window,
  void Function(BuildContext context) read,
) async {
  setWindowSize(tester, window);
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          read(context);
          return const SizedBox();
        },
      ),
    ),
  );
}

void main() {
  group('BuildContext extensions', () {
    testWidgets('size class flags at 1200 x 800', (tester) async {
      late WindowSizeClass sizeClass;
      late List<bool> flags;
      await _pumpWith(tester, const Size(1200, 800), (c) {
        sizeClass = c.windowSizeClass;
        flags = [
          c.isCompact,
          c.isMedium,
          c.isExpanded,
          c.isLarge,
          c.isWide,
          c.isLandscape,
          c.isPortrait,
        ];
      });

      expect(sizeClass, WindowSizeClass.large);
      expect(flags, [false, false, false, true, true, true, false]);
    });

    testWidgets('responsiveValue picks by size class', (tester) async {
      late String value;
      await _pumpWith(tester, const Size(1200, 800), (c) {
        value = c.responsiveValue<String>(
          compact: 'Phone',
          medium: 'Tablet',
          expanded: 'Desktop',
        );
      });
      expect(value, 'Desktop'); // large falls back to expanded
    });

    testWidgets('spacing is the wide scale on wide windows', (tester) async {
      late double md;
      await _pumpWith(tester, const Size(1200, 800), (c) => md = c.spacing.md);
      expect(md, 20);
    });

    testWidgets('spacing is the compact scale on phones', (tester) async {
      late double md;
      await _pumpWith(tester, const Size(360, 800), (c) => md = c.spacing.md);
      expect(md, 16);
    });
  });

  group('num extensions', () {
    testWidgets('responsive on a large window', (tester) async {
      late double value;
      await _pumpWith(tester, const Size(1200, 800), (c) {
        value = 100.responsive(c, medium: 200, large: 300);
      });
      expect(value, 300);
    });

    testWidgets('responsive falls back from expanded to medium',
        (tester) async {
      late double value;
      await _pumpWith(tester, const Size(900, 800), (c) {
        value = 100.responsive(c, medium: 200);
      });
      expect(value, 200);
    });

    testWidgets('responsive keeps the base value on phones', (tester) async {
      late double value;
      await _pumpWith(tester, const Size(360, 800), (c) {
        value = 100.responsive(c, medium: 200);
      });
      expect(value, 100);
    });

    testWidgets('fluid, clampedW, clampedH', (tester) async {
      late double fluid;
      late double clampedW;
      late double clampedH;
      await _pumpWith(tester, const Size(1200, 800), (c) {
        fluid = 16.fluid(c, max: 24);
        clampedW = 100.clampedW(c);
        clampedH = 100.clampedH(c);
      });

      expect(fluid, 24);
      // 1200 / 375 = 3.2, clamped to 1.35: never 320.
      expect(clampedW, 135.0);
      // 800 / 812 = 0.985, inside [0.85, 1.35].
      expect(clampedH, closeTo(98.52, 0.01));
    });

    testWidgets('widthPercent and heightPercent', (tester) async {
      late double w;
      late double h;
      await _pumpWith(tester, const Size(1200, 800), (c) {
        w = 50.widthPercent(c);
        h = 25.heightPercent(c);
      });
      expect(w, 600);
      expect(h, 200);
    });

    test('gaps are SizedBoxes', () {
      final w = 8.gapW as SizedBox;
      final h = 4.gapH as SizedBox;
      expect(w.width, 8);
      expect(w.height, isNull);
      expect(h.height, 4);
      expect(h.width, isNull);
    });
  });

  group('num.textScaled', () {
    Future<double> read(
      WidgetTester tester,
      double scale, {
      double? maxScaleFactor,
    }) async {
      late double result;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Builder(
            builder: (context) {
              result = 16.textScaled(context, maxScaleFactor: maxScaleFactor);
              return const SizedBox();
            },
          ),
        ),
      );
      return result;
    }

    testWidgets('is unchanged without text scaling', (tester) async {
      expect(await read(tester, 1.0), 16);
    });

    testWidgets('follows the system text scale', (tester) async {
      expect(await read(tester, 3.0), 48);
    });

    testWidgets('is capped by maxScaleFactor', (tester) async {
      expect(await read(tester, 3.0, maxScaleFactor: 2), 32);
    });

    testWidgets('is not capped below the cap', (tester) async {
      expect(await read(tester, 1.5, maxScaleFactor: 2), 24);
    });
  });
}
