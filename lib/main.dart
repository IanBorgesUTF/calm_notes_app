import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/pages/home/home.dart';
import 'package:calm_notes_app/pages/welcome/welcome.dart';
import 'package:calm_notes_app/providers/notes/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final sp = await SharedPreferences.getInstance();
  final seen = sp.getBool('seen_welcome_v1') ?? false;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()..loadNotes()),
      ], child:
    CalmNotesApp(initialHome: seen ? const HomePage() : const WelcomePage())));
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
