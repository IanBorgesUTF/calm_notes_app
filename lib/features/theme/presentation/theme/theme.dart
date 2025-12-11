import 'package:flutter/material.dart';

const slate = Color(0xFF1F2937);
const mint = Color(0xFF10B981);
const amber = Color(0xFFF59E0B);
const errorRed = Color(0xFFEF4444);

// LIGHT -------------------------------------------------

final ColorScheme lightScheme = ColorScheme.fromSeed(
  seedColor: mint,
  brightness: Brightness.light,
).copyWith(
  primary: mint,
  secondary: amber,
  error: errorRed,
);

// DARK --------------------------------------------------

final ColorScheme darkScheme = ColorScheme.fromSeed(
  seedColor: mint,
  brightness: Brightness.dark,
).copyWith(
  primary: mint,
  secondary: amber,
  error: errorRed,
);

// THEMES ------------------------------------------------

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightScheme,
  scaffoldBackgroundColor: lightScheme.surfaceBright,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkScheme,
  scaffoldBackgroundColor: slate,
);
