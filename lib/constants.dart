import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1A73E8); // Bright Blue
  static const Color secondaryColor = Color(0xFFE3F2FD); // Light Blue Background
  static const Color sidebarColor = Color(0xFF1A237E); // Dark Blue Sidebar Background
  static const Color whiteColor = Colors.white; // White
  static const Color blackColor = Colors.black; // Black
  static const Color greyColor = Colors.grey; // Grey
  static const Color accentColor = Color(0xFF00C853); // Bright Green Accent
  static const Color darkGrey = Color(0xFF424242); // Dark Grey
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
    fontWeight: FontWeight.w300,
    color: AppColors.blackColor,
  );

  static const TextStyle drawerHeader = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle listItem = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle deviceCardTitle = TextStyle(
    fontSize: 18,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle deviceDetails = TextStyle(
    color: AppColors.darkGrey,
    wordSpacing: 3,
    letterSpacing: 1,
  );
}
