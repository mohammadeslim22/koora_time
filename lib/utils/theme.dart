import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    primaryColor: Color(0xFF85C23F),
    accentColor: Color(0xFF85C23F),
    scaffoldBackgroundColor: Color(0xFFFAFAFA),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: Color(0xFF85C23F),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontFamily: 'DINNextLTArabic',
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
  );
}
