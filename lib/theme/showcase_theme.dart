// Visual tokens aligned with the parent V-IRAL app (minimal subset).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VIralColors {
  static const neon = Color(0xFF00FF33);
  static const neonInk = Color(0xFF0A1F0D);
  static const charcoal1 = Color(0xFF1A1A1A);
  static const charcoal2 = Color(0xFF242424);
  static const charcoal3 = Color(0xFF2E2E2E);
  static const fg1 = Color(0xFFFFFFFF);
  static const fg2 = Color(0xB3FFFFFF);
  static const fg3 = Color(0x80FFFFFF);
  static const warn = Color(0xFFFFB020);
  static Color glass = Colors.white.withValues(alpha: 0.04);
  static Color glassBorder2 = Colors.white.withValues(alpha: 0.14);
}

class VIralRadii {
  static const double lg = 28;
  static BorderRadius get rLg => BorderRadius.circular(lg);
}

class VIralSpace {
  static const double s2 = 8;
  static const double s4 = 16;
  static const double s5 = 20;
}

class VIralShadows {
  static List<BoxShadow> glowNeonSm = [
    BoxShadow(
      color: VIralColors.neon.withValues(alpha: 0.35),
      blurRadius: 12,
      spreadRadius: -2,
    ),
  ];
}

class VIralText {
  static TextStyle _ui(
    double size,
    FontWeight w, {
    Color? color,
    double? lh,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: w,
        color: color ?? VIralColors.fg1,
        height: lh,
      );

  static TextStyle h3 = _ui(20, FontWeight.w600, lh: 1.3);
  static TextStyle body = _ui(15, FontWeight.w400, lh: 1.5);
  static TextStyle small =
      _ui(13, FontWeight.w400, color: VIralColors.fg2, lh: 1.5);
  static TextStyle button = _ui(15, FontWeight.w700, lh: 1);
}
