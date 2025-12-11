import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final saved = prefs.getString('theme_mode');

    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (saved == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system; 
    }

    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    if (mode == ThemeMode.dark) {
      prefs.setString('theme_mode', 'dark');
    } else if (mode == ThemeMode.light) {
      prefs.setString('theme_mode', 'light');
    } else {
      prefs.setString('theme_mode', 'system');
    }
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  void setSystem() {
    _themeMode = ThemeMode.system;
    _saveTheme(_themeMode);
    notifyListeners();
  }

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

  void toggleTheme() {
  if (_themeMode == ThemeMode.system || _themeMode == ThemeMode.light) {
    _themeMode = ThemeMode.dark;
  } else {
    _themeMode = ThemeMode.light;
  }
  notifyListeners();
}

}
