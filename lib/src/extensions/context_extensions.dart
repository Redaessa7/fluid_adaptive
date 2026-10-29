import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';
import 'package:fluid_adaptive/src/core/responsive_info.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';
import 'package:fluid_adaptive/src/tokens/spacing_tokens.dart';

/// Responsive queries on [BuildContext].
///
/// All of them describe the nearest responsive builder's space, or the whole
/// window when there is none (see [ResponsiveScope.of]).
extension ResponsiveContextExtension on BuildContext {
  /// The active [ResponsiveInfo].
  ResponsiveInfo get responsive => ResponsiveScope.of(this);

  /// The spacing scale for the active size class:
  /// ```dart
  /// SizedBox(height: context.spacing.md)
  /// ```
  ResponsiveSpacingTokens get spacing =>
      ResponsiveSpacingTokens.forSizeClass(responsive.sizeClass);

  /// The active [WindowSizeClass].
  WindowSizeClass get windowSizeClass => responsive.sizeClass;

  /// True when the active size class is compact (< 600dp).
  bool get isCompact => responsive.isCompact;

  /// True when the active size class is medium (600dp - 839dp).
  bool get isMedium => responsive.isMedium;

  /// True when the active size class is expanded (840dp - 1199dp).
  bool get isExpanded => responsive.isExpanded;

  /// True when the active size class is large (>= 1200dp).
  bool get isLarge => responsive.isLarge;

  /// True when the width allows multi-column layouts (>= 600dp).
  bool get isWide => responsive.isWide;

  /// True when the available area is wider than tall.
  bool get isLandscape => responsive.isLandscape;

  /// True when the available area is at least as tall as wide.
  bool get isPortrait => responsive.isPortrait;

  /// Picks a value for the active size class (see [ResponsiveInfo.value]).
  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    return responsive.value(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
    );
  }
}
