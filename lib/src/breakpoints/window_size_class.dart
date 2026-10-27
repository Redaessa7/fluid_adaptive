/// Semantic window size classification for adaptive responsive design.
///
/// Follows modern design system standards (such as Material 3 window size classes).
/// Classification is always derived from available width in logical pixels,
/// never solely from device hardware type or orientation.
enum WindowSizeClass {
  /// Phone-width screens (< 600dp): single-column vertical rhythms.
  compact,

  /// Small tablets, foldables unfolded, landscape phones (600dp - 839dp).
  medium,

  /// Large tablets, desktop windows (840dp - 1199dp).
  expanded,

  /// Large desktops, ultra-wide screens (>= 1200dp).
  large;

  /// True when width is below standard tablet breakpoint (< 600dp).
  bool get isCompact => this == WindowSizeClass.compact;

  /// True when width is between 600dp and 839dp.
  bool get isMedium => this == WindowSizeClass.medium;

  /// True when width is between 840dp and 1199dp.
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// True when width is at or above 1200dp.
  bool get isLarge => this == WindowSizeClass.large;

  /// True for any screen wide enough for multi-column / adaptive content (>= 600dp).
  bool get isWide => this != WindowSizeClass.compact;

  /// Semantic alias for phone layout.
  bool get isPhone => isCompact;

  /// Semantic alias for tablet layouts (medium & expanded).
  bool get isTablet => isMedium || isExpanded;

  /// Semantic alias for desktop / wide screens (large).
  bool get isDesktop => isLarge;

  /// Resolves a value corresponding to the current window size class.
  ///
  /// Falls back to the nearest smaller size if a larger size is not provided:
  /// - [large] falls back to [expanded], then [medium], then [compact].
  /// - [expanded] falls back to [medium], then [compact].
  /// - [medium] falls back to [compact].
  T resolve<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    switch (this) {
      case WindowSizeClass.large:
        return large ?? expanded ?? medium ?? compact;
      case WindowSizeClass.expanded:
        return expanded ?? medium ?? compact;
      case WindowSizeClass.medium:
        return medium ?? compact;
      case WindowSizeClass.compact:
        return compact;
    }
  }
}
