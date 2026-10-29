/// Semantic window size classification (Material 3 window size classes).
///
/// The class is always derived from the **available width** in logical pixels,
/// never from device hardware type or orientation.
enum WindowSizeClass {
  /// Phone-width screens (< 600dp): single-column layouts.
  compact,

  /// Small tablets, unfolded foldables, landscape phones (600dp - 839dp).
  medium,

  /// Large tablets and small laptops (840dp - 1199dp).
  expanded,

  /// Desktop windows and ultra-wide screens (>= 1200dp).
  large;

  /// True for [WindowSizeClass.compact].
  bool get isCompact => this == WindowSizeClass.compact;

  /// True for [WindowSizeClass.medium].
  bool get isMedium => this == WindowSizeClass.medium;

  /// True for [WindowSizeClass.expanded].
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// True for [WindowSizeClass.large].
  bool get isLarge => this == WindowSizeClass.large;

  /// True for every class except [WindowSizeClass.compact]; wide enough for
  /// multi-column content.
  bool get isWide => this != WindowSizeClass.compact;

  /// Picks the value for this class, falling back to the nearest smaller class
  /// when a larger one is not provided:
  ///
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
