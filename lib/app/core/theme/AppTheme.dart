import 'package:flutter/material.dart';

class AppTheme {
  // ----------- Light Theme -----------
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffECEEF2),
    primaryColor: const Color(0xff038EF1),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: "Cairo",
        fontSize: 18,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: "Cairo",
      ),
    ),
  );

  // ----------- Dark Theme -----------
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff121212),
    primaryColor: const Color(0xff038EF1),
    cardColor: const Color(0xff1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: "Cairo",
        fontSize: 18,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: "Cairo",
      ),
    ),
  );
}
