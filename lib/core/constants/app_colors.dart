import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Coffee Palette
  static const Color primaryCoffee = Color(0xFFC67C4E); // Warm rich amber caramel
  static const Color primaryCoffeeDark = Color(0xFFA05324);
  static const Color primaryCoffeeLight = Color(0xFFEDD6C8);
  static const Color primaryEspresso = Color(0xFF2C1810); // Deep rich espresso
  static const Color mocha = Color(0xFF4A2810);

  // Background & Surface - Light
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFECE5DF);
  static const Color oatMilk = Color(0xFFF5EFEB);

  // Background & Surface - Dark
  static const Color backgroundDark = Color(0xFF0F0E0E);
  static const Color surfaceDark = Color(0xFF1B1917);
  static const Color cardDark = Color(0xFF24201D);
  static const Color borderDark = Color(0xFF38312B);

  // Neutral & Typography
  static const Color textDark = Color(0xFF1B1816);
  static const Color textMutedLight = Color(0xFF8A827B);
  static const Color textLight = Color(0xFFF5EFEB);
  static const Color textMutedDark = Color(0xFFA59D96);

  // Accents & Badges
  static const Color accentGold = Color(0xFFF5A623);
  static const Color accentGreen = Color(0xFF2D8A4E);
  static const Color accentRed = Color(0xFFD32F2F);
  static const Color accentBlue = Color(0xFF1976D2);

  // Luxury Gradients
  static const LinearGradient coffeeGradient = LinearGradient(
    colors: [Color(0xFFC67C4E), Color(0xFFA05324)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkEspressoGradient = LinearGradient(
    colors: [Color(0xFF2C1810), Color(0xFF160B07)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [
      Color(0x33FFFFFF),
      Color(0x0AFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
