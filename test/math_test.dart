import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  group('ResponsiveFluid.clampedLerp', () {
    double at(double w) => ResponsiveFluid.clampedLerp(
          width: w,
          min: 16,
          max: 24,
          minWidth: 400,
          maxWidth: 1200,
        );

    test('interpolates inside the range and clamps outside', () {
      expect(at(300), 16);
      expect(at(400), 16);
      expect(at(800), 20);
      expect(at(1200), 24);
      expect(at(3000), 24);
    });

    test('handles NaN and infinite widths', () {
      expect(
        ResponsiveFluid.clampedLerp(width: double.nan, min: 10, max: 20),
        10,
      );
      expect(
        ResponsiveFluid.clampedLerp(width: double.infinity, min: 10, max: 20),
        20,
      );
    });

    test('asserts on an inverted range in debug', () {
      expect(
        () => ResponsiveFluid.clampedLerp(
          width: 500,
          min: 10,
          max: 20,
          minWidth: 400,
          maxWidth: 400,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ResponsiveGutters', () {
    test('uses the phone gutter below contentMaxWidth', () {
      expect(ResponsiveGutters.sideOf(360, gutter: 16), 16);
      expect(ResponsiveGutters.sideOf(600, gutter: 16), 16);
      expect(ResponsiveGutters.sideOf(720, gutter: 16), 16);
    });

    test('centres content above contentMaxWidth', () {
      expect(ResponsiveGutters.sideOf(1200, gutter: 16), 240);
      expect(
        ResponsiveGutters.sideOf(1000, gutter: 16, contentMaxWidth: 800),
        100,
      );
    });

    test('ignores non-finite and non-positive widths', () {
      expect(ResponsiveGutters.sideOf(double.infinity, gutter: 16), 16);
      expect(ResponsiveGutters.sideOf(double.nan, gutter: 16), 16);
      expect(ResponsiveGutters.sideOf(0, gutter: 16), 16);
    });

    test('horizontal builds symmetric insets', () {
      expect(
        ResponsiveGutters.horizontal(1200, gutter: 16, vertical: 8),
        const EdgeInsets.symmetric(horizontal: 240, vertical: 8),
      );
    });
  });

  group('ResponsiveSpacingTokens', () {
    test('compact and wide scales', () {
      const compact = ResponsiveSpacingTokens.compact;
      const wide = ResponsiveSpacingTokens.wide;
      expect(
        [compact.xs, compact.sm, compact.md, compact.lg, compact.xl, compact.xxl],
        [4, 8, 16, 24, 32, 48],
      );
      expect(
        [wide.xs, wide.sm, wide.md, wide.lg, wide.xl, wide.xxl],
        [4, 8, 20, 32, 48, 64],
      );
    });

    test('forSizeClass picks the right scale', () {
      expect(
        ResponsiveSpacingTokens.forSizeClass(WindowSizeClass.compact),
        same(ResponsiveSpacingTokens.compact),
      );
      for (final c in [
        WindowSizeClass.medium,
        WindowSizeClass.expanded,
        WindowSizeClass.large,
      ]) {
        expect(
          ResponsiveSpacingTokens.forSizeClass(c),
          same(ResponsiveSpacingTokens.wide),
        );
      }
    });
  });
}
