// import 'package:flutter/material.dart';

// class AppThemes {
//   static ThemeData lightMode = ThemeData(
//     brightness: Brightness.light,
//     colorScheme: const ColorScheme.light(
//       primary: Colors.black, // Apple's primary dark color for text/icons
//       onPrimary: Colors.white, // Text/icons on primary
//       secondary: Colors.grey, // Neutral secondary color
//       onSecondary: Colors.white, // Text/icons on secondary
//       background: Colors.white, // White Background
//       onBackground: Colors.black, // Text/icons on background
//       surface: Colors.white, // Card/Container background
//       onSurface: Colors.black, // Text/icons on surface
//       error: Colors.red, // Error color
//       onError: Colors.white, // Text/icons on error
//     ),
//     scaffoldBackgroundColor: Colors.white, // White Background
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white, // AppBar Background
//       titleTextStyle: TextStyle(
//         color: Colors.black,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       iconTheme: IconThemeData(color: Colors.black), // Dark Icon Color
//     ),
//     drawerTheme: DrawerThemeData(
//       backgroundColor: Colors.white, // White Sidebar Background
//     ),
//     textTheme: const TextTheme(
//       titleLarge: TextStyle(
//         fontSize: 24,
//         color: Colors.black,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       titleMedium: TextStyle(
//         color: Colors.black,
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       bodySmall: TextStyle(
//         color: Colors.black,
//         fontSize: 13,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       bodyMedium: TextStyle(
//         fontSize: 18,
//         color: Colors.black87,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//     ),
//     buttonTheme: ButtonThemeData(
//       buttonColor: Colors.black, // Dark Accent for Buttons
//       textTheme: ButtonTextTheme.primary,
//     ),
//   );

//   static ThemeData darkMode = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: const ColorScheme.dark(
//       primary: Colors.white, // Apple's primary light color for text/icons
//       onPrimary: Colors.black, // Text/icons on primary
//       secondary: Colors.grey, // Neutral secondary color
//       onSecondary: Colors.white, // Text/icons on secondary
//       background: Color(0xFF1C1C1E), // Dark Background
//       onBackground: Colors.white, // Text/icons on background
//       surface: Color(0xFF2C2C2E), // Slightly Lighter Dark Surface
//       onSurface: Colors.white, // Text/icons on surface
//       error: Colors.redAccent, // Error color
//       onError: Colors.white, // Text/icons on error
//     ),
//     scaffoldBackgroundColor: Color(0xFF1C1C1E), // Dark Background
//     appBarTheme: AppBarTheme(
//       backgroundColor: Color(0xFF2C2C2E), // Dark AppBar
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       iconTheme: IconThemeData(color: Colors.white), // Light Icon Color
//     ),
//     drawerTheme: DrawerThemeData(
//       backgroundColor: Color(0xFF2C2C2E), // Dark Sidebar Background
//     ),
//     textTheme: const TextTheme(
//       titleLarge: TextStyle(
//         fontSize: 24,
//         color: Colors.white,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       titleMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       bodySmall: TextStyle(
//         color: Colors.white,
//         fontSize: 13,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//       bodyMedium: TextStyle(
//         fontSize: 18,
//         color: Colors.white70,
//         fontFamily: 'San Francisco, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
//       ),
//     ),
//     buttonTheme: ButtonThemeData(
//       buttonColor: Colors.white, // Light Accent for Buttons
//       textTheme: ButtonTextTheme.primary,
//     ),
//   );
// }

/*
     -----------------------------dropbox (blue theme)-----------------------------

     import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007EE5), // Dropbox Blue
      onPrimary: Colors.white, // Text/icons on primary
      secondary: Color(0xFF00A3E0), // Light Blue Accent
      onSecondary: Colors.white, // Text/icons on secondary
      background: Color(0xFFF5F7FA), // Light Grey Background
      onBackground: Colors.black, // Text/icons on background
      surface: Colors.white, // Card/Container background
      onSurface: Colors.black, // Text/icons on surface
      error: Colors.red, // Error color
      onError: Colors.white, // Text/icons on error
    ),
    scaffoldBackgroundColor: Color(0xFFF5F7FA), // Light Grey Background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF007EE5), // Dropbox Blue AppBar
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      iconTheme: IconThemeData(color: Colors.white), // White Icon Color
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF007EE5), // Dropbox Blue Sidebar Background
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF007EE5), // Dropbox Blue Accent
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF007EE5), // Dropbox Blue
      onPrimary: Colors.white, // Text/icons on primary
      secondary: Color(0xFF00A3E0), // Light Blue Accent
      onSecondary: Colors.black, // Text/icons on secondary
      background: Color(0xFF1C1C1E), // Dark Grey Background
      onBackground: Colors.white, // Text/icons on background
      surface: Color(0xFF2C2C2E), // Darker Grey Surface
      onSurface: Colors.white, // Text/icons on surface
      error: Colors.redAccent, // Error color
      onError: Colors.white, // Text/icons on error
    ),
    scaffoldBackgroundColor: Color(0xFF1C1C1E), // Dark Grey Background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2C2C2E), // Darker Grey AppBar
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      iconTheme: IconThemeData(color: Color(0xFF007EE5)), // Dropbox Blue Icon Color
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF007EE5), // Dropbox Blue Sidebar Background
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.white70,
        fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF007EE5), // Dropbox Blue Accent
      textTheme: ButtonTextTheme.primary,
    ),
  );
}



*/




 //   --------------------mint green --------------------------
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







