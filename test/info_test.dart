import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  group('ResponsiveInfo.fromSize', () {
    test('classifies by width', () {
      expect(ResponsiveInfo.fromSize(const Size(360, 800)).isCompact, isTrue);
      expect(ResponsiveInfo.fromSize(const Size(700, 900)).isMedium, isTrue);
      expect(ResponsiveInfo.fromSize(const Size(900, 900)).isExpanded, isTrue);
      expect(ResponsiveInfo.fromSize(const Size(1300, 900)).isLarge, isTrue);
    });

    test('window size defaults to the given size', () {
      final info = ResponsiveInfo.fromSize(const Size(700, 900));
      expect(info.windowSize, const Size(700, 900));
      expect(info.isWide, isTrue);
    });

    test('orientation follows the local size', () {
      expect(ResponsiveInfo.fromSize(const Size(900, 400)).isLandscape, isTrue);
      expect(ResponsiveInfo.fromSize(const Size(400, 900)).isPortrait, isTrue);
    });

    test('uses custom breakpoints', () {
      const custom = ResponsiveBreakpoints(compactMax: 800, mediumMax: 1000);
      final info = ResponsiveInfo.fromSize(
        const Size(700, 900),
        breakpoints: custom,
      );
      expect(info.isCompact, isTrue);
    });
  });

  group('ResponsiveInfo helpers', () {
    final wide = ResponsiveInfo.fromSize(const Size(1200, 800));
    final phone = ResponsiveInfo.fromSize(const Size(375, 800));

    test('value falls back to smaller classes', () {
      expect(wide.value(compact: 'a', medium: 'b'), 'b');
      expect(phone.value(compact: 'a', medium: 'b'), 'a');
    });

    test('gutter and gutters', () {
      expect(phone.gutter(), 16);
      expect(wide.gutter(), 240);
      expect(
        wide.gutters(vertical: 8),
        const EdgeInsets.symmetric(horizontal: 240, vertical: 8),
      );
      expect(
        wide.gutters(contentMaxWidth: 800),
        const EdgeInsets.symmetric(horizontal: 200),
      );
    });

    test('columns', () {
      expect(phone.columns(), 2);
      expect(wide.columns(), 7);
    });

    test('fluid follows the local width', () {
      expect(phone.fluid(min: 16, max: 24), 16);
      expect(wide.fluid(min: 16, max: 24), 24);
    });

    test('equality, hashCode and toString', () {
      final again = ResponsiveInfo.fromSize(const Size(1200, 800));
      expect(wide, again);
      expect(wide.hashCode, again.hashCode);
      expect(wide == phone, isFalse);
      expect(wide.toString(), contains('large'));
    });
  });
}
