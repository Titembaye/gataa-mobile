import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Couleurs ─────────────────────────────────────────────────────────────────

abstract class GataaColors {
  static const Color navy          = Color(0xFF0F2540);
  static const Color navyLight     = Color(0xFF1A3A5C);
  static const Color navySurface   = Color(0xFFE8EEF5);

  static const Color success       = Color(0xFF2A6042);
  static const Color successLight  = Color(0xFFE8F5EE);
  static const Color successBorder = Color(0xFFB0D4BC);

  static const Color warning       = Color(0xFFB85C00);
  static const Color warningLight  = Color(0xFFFEF3E2);
  static const Color warningBorder = Color(0xFFF5C48A);

  static const Color danger        = Color(0xFFA63228);
  static const Color dangerLight   = Color(0xFFFDECEA);
  static const Color dangerBorder  = Color(0xFFF5B8B4);

  static const Color sand          = Color(0xFFFAF7F4);
  static const Color white         = Color(0xFFFFFFFF);
  static const Color border        = Color(0xFFE8E2DA);
  static const Color borderStrong  = Color(0xFFC8C0B6);

  static const Color ink           = Color(0xFF1A1614);
  static const Color textSecondary = Color(0xFF5C5248);
  static const Color textMuted     = Color(0xFF8A7E76);
  static const Color textOnDark    = Color(0xFFFFFFFF);

  static const Color markerNormal  = Color(0xFF2A6042);
  static const Color markerHigh    = Color(0xFFB85C00);
  static const Color markerAlert   = Color(0xFFA63228);
}

// ─── Niveau de prix des marqueurs ─────────────────────────────────────────────

enum MarkerLevel { normal, high, alert }

Color markerColor(MarkerLevel level) {
  switch (level) {
    case MarkerLevel.normal: return GataaColors.markerNormal;
    case MarkerLevel.high:   return GataaColors.markerHigh;
    case MarkerLevel.alert:  return GataaColors.markerAlert;
  }
}

// ─── Espacement ───────────────────────────────────────────────────────────────

abstract class GataaSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 24.0;
  static const double xxl = 32.0;

  static const double screenH = 16.0;
  static const double screenV = 20.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: screenV,
  );

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 14.0,
  );
}

// ─── Border Radius ────────────────────────────────────────────────────────────

abstract class GataaRadius {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double pill = 100.0;

  static const BorderRadius xsAll   = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll   = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

// ─── Typographie ─────────────────────────────────────────────────────────────

abstract class GataaTypo {
  static const String _sans = 'DM Sans';
  static const String _mono = 'DM Mono';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: GataaColors.ink,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: GataaColors.ink,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: GataaColors.ink,
    height: 1.3,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: GataaColors.ink,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: GataaColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: GataaColors.ink,
    height: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: GataaColors.textMuted,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _mono,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: GataaColors.textMuted,
    letterSpacing: 1.2,
    height: 1.3,
  );

  static const TextStyle priceDisplay = TextStyle(
    fontFamily: _sans,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: GataaColors.navy,
    height: 1.0,
  );

  static const TextStyle onDark = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: GataaColors.textOnDark,
    height: 1.2,
  );
}

// ─── ThemeData Flutter ────────────────────────────────────────────────────────

class GataaTheme {
  GataaTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: GataaColors.navy,
        onPrimary: GataaColors.textOnDark,
        primaryContainer: GataaColors.navySurface,
        onPrimaryContainer: GataaColors.navy,
        secondary: GataaColors.success,
        onSecondary: GataaColors.textOnDark,
        error: GataaColors.danger,
        onError: GataaColors.textOnDark,
        surface: GataaColors.white,
        onSurface: GataaColors.ink,
        surfaceContainerHighest: GataaColors.sand,
        outline: GataaColors.border,
      ),
      scaffoldBackgroundColor: GataaColors.sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: GataaColors.navy,
        foregroundColor: GataaColors.textOnDark,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: GataaColors.textOnDark,
        ),
        iconTheme: IconThemeData(color: GataaColors.textOnDark),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: GataaColors.navy,
        selectedItemColor: GataaColors.textOnDark,
        unselectedItemColor: Color(0x80FFFFFF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'DM Mono',
          fontSize: 10,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'DM Mono',
          fontSize: 10,
        ),
      ),
      cardTheme: CardThemeData(
        color: GataaColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: GataaRadius.mdAll,
          side: const BorderSide(color: GataaColors.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GataaColors.navy,
          foregroundColor: GataaColors.textOnDark,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: GataaRadius.mdAll),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GataaColors.navy,
          side: const BorderSide(color: GataaColors.navy, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: GataaRadius.mdAll),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GataaColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: GataaRadius.smAll,
          borderSide: const BorderSide(color: GataaColors.border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: GataaRadius.smAll,
          borderSide: const BorderSide(color: GataaColors.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GataaRadius.smAll,
          borderSide: const BorderSide(color: GataaColors.navy, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: GataaRadius.smAll,
          borderSide: const BorderSide(color: GataaColors.danger, width: 1),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          color: GataaColors.textMuted,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: GataaColors.border,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}

// ─── Widgets utilitaires ──────────────────────────────────────────────────────

class PriceBadge extends StatelessWidget {
  const PriceBadge({super.key, required this.variation, this.days = 7});

  final double variation;
  final int days;

  static Color _bg(double v) {
    if (v > 0.15) return GataaColors.dangerLight;
    if (v > 0.05) return GataaColors.warningLight;
    if (v < -0.03) return GataaColors.successLight;
    return const Color(0xFFF5F3EF);
  }

  static Color _fg(double v) {
    if (v > 0.15) return GataaColors.danger;
    if (v > 0.05) return GataaColors.warning;
    if (v < -0.03) return GataaColors.success;
    return GataaColors.textMuted;
  }

  static String _label(double v, int days) {
    final pct = (v * 100).abs().toStringAsFixed(0);
    final sign = v > 0.005 ? '↑ +' : (v < -0.005 ? '↓ -' : '');
    final suffix = ' / ${days}j';
    return v.abs() < 0.005 ? 'stable' : '$sign$pct%$suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bg(variation),
        borderRadius: GataaRadius.pillAll,
      ),
      child: Text(
        _label(variation, days),
        style: GataaTypo.labelMedium.copyWith(
          color: _fg(variation),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class GataaCard extends StatelessWidget {
  const GataaCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GataaColors.white,
      borderRadius: GataaRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: GataaRadius.mdAll,
        child: Container(
          padding: padding ?? GataaSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: GataaRadius.mdAll,
            border: Border.all(color: GataaColors.border, width: 0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GataaSectionLabel extends StatelessWidget {
  const GataaSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GataaSpacing.md),
      child: Text(text.toUpperCase(), style: GataaTypo.labelSmall),
    );
  }
}