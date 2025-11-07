import 'package:flutter/material.dart';
import 'tokens.gen.dart';

class AppTheme {
  static ThemeData light() {
    final primary = Color(Tokens.color_brand_primary);
    final secondary = Color(Tokens.color_brand_secondary);

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(Tokens.color_brand_primary),
      onPrimary: Colors.white,
      secondary: Color(Tokens.color_brand_secondary),
      onSecondary: Colors.white,
      surface: Color(Tokens.color_background_surface),
      onSurface: Color(Tokens.color_text_primary),
      background: Colors.white, // 今は固定・後で tokens に合わせて変更
      onBackground: Color(Tokens.color_text_primary),
      error: Color(Tokens.color_semantic_error),
      onError: Colors.white,
      tertiary: Color(Tokens.color_semantic_success),
      onTertiary: Colors.white,
    );

    final textTheme = TextTheme(
      headlineMedium: TextStyle(
        fontSize: Tokens.typography_heading_2_fontSize,
        fontWeight: FontWeight.w600,
        height: Tokens.typography_heading_2_lineHeight,
      ),
      bodyLarge: TextStyle(
        fontSize: Tokens.typography_body_md_fontSize,
        fontWeight: FontWeight.w400,
        height: Tokens.typography_body_md_lineHeight,
      ),
      bodyMedium: TextStyle(
        fontSize: Tokens.typography_body_sm_fontSize,
        fontWeight: FontWeight.w400,
        height: Tokens.typography_body_sm_lineHeight,
      ),
      labelLarge: TextStyle(
        fontSize: Tokens.typography_caption_default_fontSize,
        fontWeight: FontWeight.w400,
        height: Tokens.typography_caption_default_lineHeight,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: colorScheme.primary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: Tokens.space_4,
            vertical: Tokens.space_3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Tokens.radius_xl),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Tokens.radius_m),
        ),
        contentPadding: EdgeInsets.all(Tokens.space_3),
      ),
    );
  }
}