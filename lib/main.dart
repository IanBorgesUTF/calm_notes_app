import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:calm_notes_app/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:calm_notes_app/features/auth/domain/usecases/create_account_usecase.dart';
import 'package:calm_notes_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:calm_notes_app/features/notes/presentation/pages/home.dart';
import 'package:calm_notes_app/features/onboarding/presentation/pages/welcome.dart';
import 'package:calm_notes_app/features/notes/presentation/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme.dart';
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

  final authDs = SupabaseAuthDataSource();
  final authRepo = AuthRepositoryImpl(authDs);
  final createAccountUseCase = CreateAccountUseCase(authRepo);


  final sp = await SharedPreferences.getInstance();
  final seen = sp.getBool('seen_welcome_v1') ?? false;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()..loadNotes()),
        ChangeNotifierProvider(create: (_) => AuthProvider(createAccountUseCase: createAccountUseCase),
        ),
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
