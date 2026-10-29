import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/breakpoints/window_size_class.dart';

/// Spacing scale that steps up (it does not scale continuously) on wide
/// windows.
///
/// Immutable value object: obtain it with `context.spacing` or
/// [ResponsiveSpacingTokens.forSizeClass].
@immutable
final class ResponsiveSpacingTokens {
  const ResponsiveSpacingTokens._({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  /// Returns [compact] for [WindowSizeClass.compact] and [wide] otherwise.
  factory ResponsiveSpacingTokens.forSizeClass(WindowSizeClass sizeClass) {
    return sizeClass.isCompact ? compact : wide;
  }

  /// Tokens for phone-width windows.
  static const ResponsiveSpacingTokens compact = ResponsiveSpacingTokens._(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );

  /// Tokens for windows of 600dp and wider.
  static const ResponsiveSpacingTokens wide = ResponsiveSpacingTokens._(
    xs: 4.0,
    sm: 8.0,
    md: 20.0,
    lg: 32.0,
    xl: 48.0,
    xxl: 64.0,
  );

  /// Extra small spacing (4dp on every window size).
  final double xs;

  /// Small spacing (8dp on every window size).
  final double sm;

  /// Medium spacing (16dp compact, 20dp wide).
  final double md;

  /// Large spacing (24dp compact, 32dp wide).
  final double lg;

  /// Extra large spacing (32dp compact, 48dp wide).
  final double xl;

  /// Extra extra large spacing (48dp compact, 64dp wide).
  final double xxl;
}
