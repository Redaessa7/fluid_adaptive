/// Package-internal default values, kept in one place (not exported).
abstract final class ResponsiveDefaults {
  /// Reference phone width used by proportional helpers (`clampedW`, `fluid`).
  static const double designWidth = 375.0;

  /// Reference phone height used by `clampedH`.
  static const double designHeight = 812.0;

  /// Default width at which fluid interpolation reaches its maximum.
  static const double fluidMaxWidth = 1200.0;

  /// Default minimum grid tile width.
  static const double minTileWidth = 170.0;

  /// Default comfortable reading width for page content.
  static const double contentMaxWidth = 720.0;

  /// Default minimum side gutter on phones.
  static const double compactGutter = 16.0;

  /// Default lower bound of the proportional scale in `clampedW` / `clampedH`.
  static const double minScale = 0.85;

  /// Default upper bound of the proportional scale in `clampedW` / `clampedH`.
  static const double maxScale = 1.35;

  /// Default minimum number of grid columns.
  static const int minColumns = 2;

  /// Default maximum number of grid columns.
  static const int maxColumns = 8;

  /// Default spacing between grid tiles.
  static const double gridSpacing = 12.0;
}
