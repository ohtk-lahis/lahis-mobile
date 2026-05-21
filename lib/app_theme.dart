import 'package:flutter/material.dart';
import 'package:podd_app/theme/ohtk_style_system.dart';

class AppTheme {
  // teal color
  Color primary = OhtkColor.teal700;
  // soft teal color
  Color secondary = OhtkColor.teal100;
  // lighter teal color
  Color tertiary = OhtkColor.teal50;
  // dark almost black
  Color bg1 = OhtkColor.ink900;
  // soft white
  Color bg2 = OhtkColor.cream;
  // gray 1
  Color sub1 = OhtkColor.ink700;
  // light gray 2
  Color sub2 = OhtkColor.ink400;
  // lighter gray 3
  Color sub3 = OhtkColor.line;
  // lightest gray (placeholder)
  Color sub4 = OhtkColor.lineSoft;
  // orange
  Color warn = OhtkColor.warning;
  // seashell soft white yellow
  Color hilight = OhtkColor.warningBg;
  // pastel red
  Color tag1 = const Color(0xFFFFB5B5);
  // pastel yellow
  Color tag2 = const Color(0xFFFFE0A4);

  double borderRadius = 10;

  Color inputTextColor = OhtkColor.ink900;

  // default font
  String font = OhtkType.family;

  ThemeData get themeData => OhtkTheme.build();
}
