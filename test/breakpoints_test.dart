import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  const bp = ResponsiveBreakpoints.standard;

  group('ResponsiveBreakpoints.sizeClassFor', () {
    test('classifies at every boundary', () {
      expect(bp.sizeClassFor(360), WindowSizeClass.compact);
      expect(bp.sizeClassFor(599.9), WindowSizeClass.compact);
      expect(bp.sizeClassFor(600), WindowSizeClass.medium);
      expect(bp.sizeClassFor(839.9), WindowSizeClass.medium);
      expect(bp.sizeClassFor(840), WindowSizeClass.expanded);
      expect(bp.sizeClassFor(1199.9), WindowSizeClass.expanded);
      expect(bp.sizeClassFor(1200), WindowSizeClass.large);
      expect(bp.sizeClassFor(5000), WindowSizeClass.large);
    });

    test('treats NaN as compact', () {
      expect(bp.sizeClassFor(double.nan), WindowSizeClass.compact);
    });

    test('rejects non-increasing breakpoints in debug', () {
      expect(
        () => ResponsiveBreakpoints(compactMax: 800, mediumMax: 700),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ResponsiveBreakpoints.columnsFor', () {
    test('uses width / minTileWidth by default', () {
      expect(bp.columnsFor(360), 2);
      expect(bp.columnsFor(600), 3);
      expect(bp.columnsFor(1024), 6);
      expect(bp.columnsFor(2000, maxColumns: 6), 6);
    });

    test('accounts for spacing and padding', () {
      // Without spacing this would be 2 columns -> (350 - 12) / 2 = 169 < 170.
      expect(
        bp.columnsFor(350, minTileWidth: 170, minColumns: 1, spacing: 12),
        1,
      );
      // 392 - 32 padding = 360 usable -> (360 + 12) / (170 + 12) = 2.04 -> 2.
      expect(
        bp.columnsFor(
          392,
          minTileWidth: 170,
          minColumns: 1,
          spacing: 12,
          padding: 32,
        ),
        2,
      );
    });

    test('never throws on odd input', () {
      expect(bp.columnsFor(800, minColumns: 5, maxColumns: 2), 5);
      expect(bp.columnsFor(0), 2);
      expect(bp.columnsFor(-50), 2);
      expect(bp.columnsFor(double.nan), 2);
      expect(bp.columnsFor(double.infinity), 2);
      expect(bp.columnsFor(800, minTileWidth: 0), 2);
      expect(bp.columnsFor(800, minColumns: 0, minTileWidth: 5000), 1);
    });
  });

  group('ResponsiveBreakpoints value semantics', () {
    test('copyWith keeps unspecified values', () {
      final custom = bp.copyWith(compactMax: 700);
      expect(custom.compactMax, 700);
      expect(custom.mediumMax, bp.mediumMax);
      expect(custom.expandedMax, bp.expandedMax);
      expect(custom.contentMaxWidth, bp.contentMaxWidth);
    });

    test('equality and hashCode follow the values', () {
      expect(bp, const ResponsiveBreakpoints());
      expect(bp.hashCode, const ResponsiveBreakpoints().hashCode);
      expect(bp == bp.copyWith(compactMax: 700), isFalse);
    });

    test('toString mentions the values', () {
      expect(bp.toString(), contains('compactMax: 600.0'));
    });
  });

  group('WindowSizeClass', () {
    test('flags', () {
      expect(WindowSizeClass.compact.isCompact, isTrue);
      expect(WindowSizeClass.compact.isWide, isFalse);
      expect(WindowSizeClass.medium.isMedium, isTrue);
      expect(WindowSizeClass.medium.isWide, isTrue);
      expect(WindowSizeClass.expanded.isExpanded, isTrue);
      expect(WindowSizeClass.large.isLarge, isTrue);
    });

    test('resolve falls back to the nearest smaller class', () {
      expect(WindowSizeClass.large.resolve(compact: 1, medium: 2), 2);
      expect(WindowSizeClass.large.resolve(compact: 1, expanded: 3), 3);
      expect(WindowSizeClass.expanded.resolve(compact: 1), 1);
      expect(
        WindowSizeClass.large
            .resolve(compact: 1, medium: 2, expanded: 3, large: 4),
        4,
      );
      expect(WindowSizeClass.medium.resolve(compact: 1), 1);
    });
  });
}
