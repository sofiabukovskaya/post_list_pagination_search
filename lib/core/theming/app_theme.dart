import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_theme.tailor.dart';

@TailorMixin()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeTailorMixin {
  const AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.background,
  });
  @override
  final Color primaryColor;
  @override
  final Color secondaryColor;
  @override
  final Color background;
}

final lightSimpleTheme = AppTheme(
  primaryColor: Colors.teal,
  secondaryColor: Colors.green,
  background: Colors.white,
);

final darkSimpleTheme = AppTheme(
  background: Colors.black,
  primaryColor: Colors.pink,
  secondaryColor: Colors.greenAccent,
);
