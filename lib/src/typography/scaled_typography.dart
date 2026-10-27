import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Accessibility-safe scaled typography helpers for both Material and Cupertino.
///
/// Respects the user's system font preference via [MediaQuery.textScalerOf]
/// while preventing runaway font blowups that destroy card layouts.
abstract final class ResponsiveTypography {
  /// Scales [style] according to ambient [TextScaler] with an optional safety cap.
  ///
  /// Works across [MaterialApp], [CupertinoApp], and custom [WidgetsApp].
  static TextStyle scaled(
    BuildContext context,
    TextStyle? style, {
    double fallbackSize = 14.0,
    double maxScaleFactor = 2.0,
  }) {
    final resolved = style ??
        _resolveDefaultBody(context, fallbackSize);

    final scaler = MediaQuery.textScalerOf(context);
    final baseSize = resolved.fontSize ?? fallbackSize;

    // Apply clamped scaling
    final scaledSize = scaler.scale(baseSize);
    final clampedSize = scaledSize.clamp(baseSize * 0.7, baseSize * maxScaleFactor);

    return resolved.copyWith(fontSize: clampedSize);
  }

  /// Title style bound to the theme's titleLarge (or Cupertino nav title), scaled for accessibility.
  static TextStyle scaledTitle(
    BuildContext context, {
    TextStyle? base,
    double fallbackSize = 20.0,
  }) {
    final style = base ?? _resolveDefaultTitle(context, fallbackSize);
    return scaled(context, style, fallbackSize: fallbackSize);
  }

  /// Body style bound to the theme's bodyMedium (or Cupertino textStyle), scaled for accessibility.
  static TextStyle scaledBody(
    BuildContext context, {
    TextStyle? base,
    double fallbackSize = 14.0,
  }) {
    final style = base ?? _resolveDefaultBody(context, fallbackSize);
    return scaled(context, style, fallbackSize: fallbackSize);
  }

  static TextStyle _resolveDefaultBody(BuildContext context, double fallbackSize) {
    try {
      final cupertino = context.findAncestorWidgetOfExactType<CupertinoApp>();
      if (cupertino != null) {
        return CupertinoTheme.of(context).textTheme.textStyle;
      }
      return Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontSize: fallbackSize);
    } catch (_) {
      return TextStyle(fontSize: fallbackSize);
    }
  }

  static TextStyle _resolveDefaultTitle(BuildContext context, double fallbackSize) {
    try {
      final cupertino = context.findAncestorWidgetOfExactType<CupertinoApp>();
      if (cupertino != null) {
        return CupertinoTheme.of(context).textTheme.navTitleTextStyle;
      }
      return Theme.of(context).textTheme.titleLarge ??
          TextStyle(fontSize: fallbackSize, fontWeight: FontWeight.bold);
    } catch (_) {
      return TextStyle(fontSize: fallbackSize, fontWeight: FontWeight.bold);
    }
  }
}

/// Extension on [TextStyle] for fluent typography scaling.
extension ResponsiveTextStyleExtension on TextStyle {
  /// Scales this text style using the ambient [BuildContext]'s text scaler.
  TextStyle responsiveScale(
    BuildContext context, {
    double maxScaleFactor = 2.0,
  }) {
    return ResponsiveTypography.scaled(
      context,
      this,
      fallbackSize: fontSize ?? 14.0,
      maxScaleFactor: maxScaleFactor,
    );
  }
}
