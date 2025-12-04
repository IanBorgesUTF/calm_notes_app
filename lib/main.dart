import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/core/sync_service.dart';
import 'package:calm_notes_app/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:calm_notes_app/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:calm_notes_app/features/auth/domain/usecases/create_account_usecase.dart';
import 'package:calm_notes_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:calm_notes_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:calm_notes_app/features/notes/data/datasources/local_notes_datasource.dart';
import 'package:calm_notes_app/features/notes/presentation/pages/home.dart';
import 'package:calm_notes_app/features/onboarding/presentation/pages/welcome.dart';
import 'package:calm_notes_app/features/notes/presentation/providers/notes_provider.dart';
import 'package:calm_notes_app/features/profile/data/datasources/local_profile_photo_datasource.dart';
import 'package:calm_notes_app/features/profile/data/datasources/supabase_profile_datasource.dart';
import 'package:calm_notes_app/features/profile/data/repositories_impl/profile_photo_repository_impl.dart';
import 'package:calm_notes_app/features/profile/data/repositories_impl/profile_repository_impl.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/get_profile_photo_path_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/remove_profile_photo_usecase.dart';
import 'package:calm_notes_app/features/profile/domain/usecases/save_profile_photo_usecase.dart';
import 'package:calm_notes_app/features/profile/presentation/providers/profile_photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
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

  await Hive.initFlutter();
  await Hive.openBox('notes_box');

  final localDs = LocalNotesDataSource(boxName: 'notes_box');
  await localDs.init();

  final syncService = SyncService(localNotesDataSource: localDs);
  await syncService.init();

  final authDs = SupabaseAuthDataSource();
  final authRepo = AuthRepositoryImpl(authDs);
  final createAccountUseCase = CreateAccountUseCase(authRepo);
  final loginUseCase = LoginUseCase(authRepo);
 
  final photoDs = LocalProfilePhotoDataSource();
  final photoRepo = ProfilePhotoRepositoryImpl(photoDs);
  final getPathUc = GetProfilePhotoPathUseCase(photoRepo);
  final saveUc = SaveProfilePhotoUseCase(photoRepo);
  final removeUc = RemoveProfilePhotoUseCase(photoRepo);

  final supabaseProfileDs = SupabaseProfileDataSource();
  final profileRepo = ProfileRepositoryImpl(supabaseProfileDs);
  final getUserUc = GetUserProfileUseCase(profileRepo);

  final sp = await SharedPreferences.getInstance();
  final seen = sp.getBool('seen_welcome_v1') ?? false;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider(localNotesDataSource: localDs, syncService: syncService)..loadNotes()),
        ChangeNotifierProvider(create: (_) => AuthProvider(createAccountUseCase: createAccountUseCase, loginUseCase: loginUseCase)),
        ChangeNotifierProvider(create: (_) => ProfilePhotoProvider(getPathUseCase: getPathUc, saveUseCase: saveUc, removeUseCase: removeUc, getUserUseCase: getUserUc)),
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
