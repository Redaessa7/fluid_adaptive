import 'package:flutter/widgets.dart';
import 'package:fluid_adaptive/src/core/responsive_scope.dart';

/// Standard 8-point grid responsive spacing tokens.
@immutable
class ResponsiveSpacingTokens {
  const ResponsiveSpacingTokens({
    required this.context,
  });

  final BuildContext context;

  /// Extra small spacing (4dp).
  double get xs => 4.0;

  /// Small spacing (8dp).
  double get sm => 8.0;

  /// Medium spacing (16dp on phone, scales smoothly on wide screens).
  double get md {
    final info = ResponsiveScope.of(context);
    return info.isWide ? 20.0 : 16.0;
  }

  /// Large spacing (24dp on phone, 32dp on wide screens).
  double get lg {
    final info = ResponsiveScope.of(context);
    return info.isWide ? 32.0 : 24.0;
  }

  /// Extra large spacing (32dp on phone, 48dp on wide screens).
  double get xl {
    final info = ResponsiveScope.of(context);
    return info.isWide ? 48.0 : 32.0;
  }

  /// Extra extra large spacing (48dp on phone, 64dp on wide screens).
  double get xxl {
    final info = ResponsiveScope.of(context);
    return info.isWide ? 64.0 : 48.0;
  }

  /// Fixed non-adaptive step tokens:
  static const double step2 = 2.0;
  static const double step4 = 4.0;
  static const double step8 = 8.0;
  static const double step12 = 12.0;
  static const double step16 = 16.0;
  static const double step20 = 20.0;
  static const double step24 = 24.0;
  static const double step32 = 32.0;
  static const double step40 = 40.0;
  static const double step48 = 48.0;
  static const double step64 = 64.0;
}

/// Standard border radius tokens.
abstract final class ResponsiveRadiusTokens {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;

  static const BorderRadius borderXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius border2XL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(full));
}
