import 'package:flutter/material.dart';

class AppColors {
  static const slate = Color.fromARGB(255, 226, 226, 226);
  static const slateDark = Color(0xFF111418);

  static const mint = Color.fromARGB(255, 98, 206, 163);
  static const mintDark = Color(0xFF047857);

  static const amber = Color(0xFFFBBF24);
  static const amberDark = Color(0xFFB45309);

  static const error = Color(0xFFE53935);
}

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.slate,
    colorScheme: const ColorScheme.light(
      primary: AppColors.mint,
      secondary: AppColors.amber,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.slate,
      foregroundColor: Colors.black87,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.slateDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.mintDark,
      secondary: AppColors.amberDark,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.slateDark,
      foregroundColor: AppColors.slate,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.slate),
    ),
  );

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
