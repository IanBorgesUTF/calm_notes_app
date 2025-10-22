import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/pages/home/home.dart';
import 'package:calm_notes_app/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final seen = sp.getBool('seen_welcome_v1') ?? false;
  runApp(CalmNotesApp(initialHome: seen ? const HomePage() : const WelcomePage()));
}

class CalmNotesApp extends StatelessWidget {
  final Widget initialHome;
  const CalmNotesApp({super.key, required this.initialHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalmNotes',
      theme: ThemeData(
        scaffoldBackgroundColor: slate,
        primaryColor: mint,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: amber),
        appBarTheme: AppBarTheme(backgroundColor: slate, foregroundColor: Colors.white),
      ),
      onGenerateRoute: Routes.generateRoute,
      home: initialHome,
      debugShowCheckedModeBanner: false,
    );
  }
}
