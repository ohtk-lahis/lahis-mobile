import 'package:flutter/material.dart';

class OhtkColor {
  const OhtkColor._();

  static const teal900 = Color(0xFF063A2E);
  static const teal800 = Color(0xFF0A4C3D);
  static const teal700 = Color(0xFF0F7B5A);
  static const teal600 = Color(0xFF14916B);
  static const teal100 = Color(0xFFD6EBE2);
  static const teal50 = Color(0xFFEAF5F0);

  static const cream = Color(0xFFF5F1EA);
  static const creamHi = Color(0xFFFAF7F1);
  static const paper = Color(0xFFFFFFFF);
  static const line = Color(0xFFE8E2D5);
  static const lineSoft = Color(0xFFF0EADE);

  static const ink900 = Color(0xFF1A1A1A);
  static const ink700 = Color(0xFF3C3C3C);
  static const ink500 = Color(0xFF6B6B6B);
  static const ink400 = Color(0xFF8A8A8A);
  static const ink300 = Color(0xFFB5B5B5);

  static const accent = Color(0xFFE07A45);
  static const accentSoft = Color(0xFFFBE5D6);

  static const danger = Color(0xFFB91C1C);
  static const dangerBg = Color(0xFFFEECEC);
  static const warning = Color(0xFF92400E);
  static const warningBg = Color(0xFFFEF3C7);
  static const success = teal700;
  static const successBg = teal100;
  static const info = Color(0xFF1E40AF);
  static const infoBg = Color(0xFFE0E7FF);
}

class OhtkType {
  const OhtkType._();

  static const family = 'Inter';
  static const fallback = <String>['NotoSansThai', 'NotoSansLao'];

  static const h1 = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.30,
    color: OhtkColor.ink900,
  );
  static const h2 = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: OhtkColor.ink900,
  );
  static const h3 = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.40,
    color: OhtkColor.ink900,
  );
  static const body = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: OhtkColor.ink700,
  );
  static const bodyStrong = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: OhtkColor.ink700,
  );
  static const small = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.40,
    color: OhtkColor.ink500,
  );
  static const eyebrow = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: 1.0,
    color: OhtkColor.ink500,
  );
  static const button = TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.00,
    letterSpacing: 0.3,
  );
}

class OhtkSpace {
  const OhtkSpace._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class OhtkRadius {
  const OhtkRadius._();

  static const tile = BorderRadius.all(Radius.circular(12));
  static const card = BorderRadius.all(Radius.circular(16));
  static const input = BorderRadius.all(Radius.circular(10));
  static const pill = BorderRadius.all(Radius.circular(999));
  static const chip = BorderRadius.all(Radius.circular(999));
}

class OhtkShadow {
  const OhtkShadow._();

  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0A141E19), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x08141E19), offset: Offset(0, 1), blurRadius: 1),
  ];
  static const raised = <BoxShadow>[
    BoxShadow(color: Color(0x14141E19), offset: Offset(0, 6), blurRadius: 16),
    BoxShadow(color: Color(0x0A141E19), offset: Offset(0, 2), blurRadius: 4),
  ];
  static const sticky = <BoxShadow>[
    BoxShadow(color: Color(0x0D141E19), offset: Offset(0, -4), blurRadius: 12),
  ];
}

class OhtkLayout {
  const OhtkLayout._();

  static const double pagePad = 16;
  static const double cardPad = 16;
  static const double rowGap = 12;
  static const double sectionGap = 24;
  static const double headerH = 56;
  static const double bottomNavH = 64;
}

class OhtkTheme {
  const OhtkTheme._();

  static ThemeData build() {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: OhtkColor.cream,
      primaryColor: OhtkColor.teal700,
      colorScheme: base.colorScheme.copyWith(
        primary: OhtkColor.teal700,
        secondary: OhtkColor.teal100,
        surface: OhtkColor.paper,
        error: OhtkColor.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OhtkColor.teal800,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: OhtkType.family,
          fontFamilyFallback: OhtkType.fallback,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textTheme: base.textTheme
          .apply(
            fontFamily: OhtkType.family,
            fontFamilyFallback: OhtkType.fallback,
          )
          .copyWith(
            titleLarge: OhtkType.h1,
            titleMedium: OhtkType.h2,
            titleSmall: OhtkType.h3,
            bodyLarge: OhtkType.body,
            bodyMedium: OhtkType.body,
            bodySmall: OhtkType.small,
            labelLarge: OhtkType.button,
          ),
      cardTheme: const CardThemeData(
        color: OhtkColor.paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: OhtkRadius.card,
          side: BorderSide(color: OhtkColor.line),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: OhtkColor.paper,
        border: OutlineInputBorder(
          borderRadius: OhtkRadius.input,
          borderSide: BorderSide(color: OhtkColor.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: OhtkRadius.input,
          borderSide: BorderSide(color: OhtkColor.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: OhtkRadius.input,
          borderSide: BorderSide(color: OhtkColor.teal700, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: OhtkRadius.input,
          borderSide: BorderSide(color: OhtkColor.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: OhtkRadius.input,
          borderSide: BorderSide(color: OhtkColor.danger, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OhtkColor.teal700,
          foregroundColor: Colors.white,
          disabledBackgroundColor: OhtkColor.line,
          disabledForegroundColor: OhtkColor.ink400,
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: OhtkType.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OhtkColor.ink700,
          side: const BorderSide(color: OhtkColor.line, width: 1.5),
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: OhtkColor.paper,
        selectedItemColor: OhtkColor.teal700,
        unselectedItemColor: OhtkColor.ink400,
        selectedIconTheme: IconThemeData(color: OhtkColor.teal700),
        unselectedIconTheme: IconThemeData(color: OhtkColor.ink400),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: OhtkColor.teal700,
        unselectedLabelColor: OhtkColor.ink500,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: OhtkColor.teal700, width: 2),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return OhtkColor.teal700;
          return OhtkColor.line;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return OhtkColor.teal700;
          return OhtkColor.paper;
        }),
        side: const BorderSide(color: OhtkColor.line, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}

enum OhtkCardTone { paper, cream, mint }

class OhtkCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final OhtkCardTone tone;
  final VoidCallback? onTap;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;

  const OhtkCard({
    required this.child,
    this.padding = const EdgeInsets.all(OhtkLayout.cardPad),
    this.margin,
    this.tone = OhtkCardTone.paper,
    this.onTap,
    this.borderColor = OhtkColor.line,
    this.boxShadow,
    super.key,
  });

  @override
  State<OhtkCard> createState() => _OhtkCardState();
}

class _OhtkCardState extends State<OhtkCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final background = switch (widget.tone) {
      OhtkCardTone.paper => OhtkColor.paper,
      OhtkCardTone.cream => OhtkColor.creamHi,
      OhtkCardTone.mint => OhtkColor.teal50,
    };
    final borderRadius = OhtkRadius.card;
    final content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
        border: Border.all(color: widget.borderColor),
        boxShadow: widget.boxShadow ??
            (widget.tone == OhtkCardTone.paper ? OhtkShadow.card : null),
      ),
      child: widget.child,
    );
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: widget.onTap == null
          ? content
          : AnimatedScale(
              scale: _pressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOutCubic,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: widget.onTap,
                  onHighlightChanged: (h) {
                    if (h != _pressed) setState(() => _pressed = h);
                  },
                  child: content,
                ),
              ),
            ),
    );
  }
}

class OhtkIconTile extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  const OhtkIconTile({
    required this.icon,
    this.size = 48,
    this.backgroundColor = OhtkColor.teal100,
    this.foregroundColor = OhtkColor.teal700,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: OhtkColor.teal100,
        borderRadius: OhtkRadius.tile,
      ).copyWith(color: backgroundColor),
      child: Icon(icon, color: foregroundColor, size: size * 0.48),
    );
  }
}

class OhtkChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool ghost;
  final bool small;

  const OhtkChip({
    required this.label,
    this.icon,
    this.ghost = false,
    this.small = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fg = ghost ? OhtkColor.ink500 : OhtkColor.teal700;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: ghost ? Colors.transparent : OhtkColor.teal100,
        borderRadius: OhtkRadius.chip,
        border: ghost ? Border.all(color: OhtkColor.line) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: small ? 12 : 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: OhtkType.family,
              fontFamilyFallback: OhtkType.fallback,
              fontSize: small ? 12 : 13,
              fontWeight: FontWeight.w600,
              height: 1,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class OhtkEyebrow extends StatelessWidget {
  final String label;
  final Color color;

  const OhtkEyebrow({
    required this.label,
    this.color = OhtkColor.ink500,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: OhtkType.eyebrow.copyWith(
        fontFamily: OhtkType.family,
        fontFamilyFallback: OhtkType.fallback,
        color: color,
      ),
    );
  }
}

class OhtkPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool block;
  final bool loading;

  const OhtkPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.block = true,
    this.loading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(label.toUpperCase()),
            ],
          );
    return SizedBox(
      width: block ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: child,
      ),
    );
  }
}

class OhtkSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const OhtkSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}
