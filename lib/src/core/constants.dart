import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4CAF50), // Fresh Green
      onPrimary: Colors.white, // Text/icons on primary
      secondary: Color(0xFF00796B), // Teal
      onSecondary: Colors.white, // Text/icons on secondary
      background: Color(0xFFE8F5E9), // Light Green Background
      onBackground: Colors.black, // Text/icons on background
      surface: Colors.white, // Card/Container background
      onSurface: Colors.black, // Text/icons on surface
      error: Colors.red, // Error color
      onError: Colors.white, // Text/icons on error
    ),
    scaffoldBackgroundColor: Color(0xFFE8F5E9), // Light Green Background
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white, // AppBar Background
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      iconTheme: IconThemeData(color: Color(0xFF4CAF50)), // Green Icon Color
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF00796B), // Teal Sidebar Background
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF4CAF50), // Fresh Green Accent
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4CAF50), // Fresh Green
      onPrimary: Colors.black, // Text/icons on primary
      secondary: Color(0xFF00796B), // Teal
      onSecondary: Colors.white, // Text/icons on secondary
      background: Color(0xFF303030), // Dark Grey Background
      onBackground: Colors.white, // Text/icons on background
      surface: Color(0xFF303030), // Card/Container background
      onSurface: Colors.white, // Text/icons on surface
      error: Colors.redAccent, // Error color
      onError: Colors.white, // Text/icons on error
    ),
    scaffoldBackgroundColor: Color(0xFF303030), // Dark Grey Background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF303030), // Dark Grey AppBar
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      iconTheme: IconThemeData(color: Color(0xFF4CAF50)), // Green Icon Color
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF00796B), // Teal Sidebar Background
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.white70,
        fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF4CAF50), // Fresh Green Accent
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
