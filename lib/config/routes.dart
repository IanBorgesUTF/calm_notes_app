import 'package:calm_notes_app/features/auth/presentation/pages/create_account_page.dart';
import 'package:calm_notes_app/features/notes/presentation/pages/editor_page.dart';
import 'package:calm_notes_app/features/notes/presentation/pages/home.dart';
import 'package:calm_notes_app/features/auth/presentation/pages/login_page.dart';
import 'package:calm_notes_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:calm_notes_app/features/onboarding/presentation/pages/terms.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String splashScreen = '/';
  static const String homePage = '/home_page';
  static const String loginPage = '/login_page';
  static const String createAccountPage = '/create_account_page';
  static const String termsConditionsPage = '/terms_page';
  static const String editorPage = '/editor_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );  
      case createAccountPage:
        return MaterialPageRoute(
          builder: (_) => const CreateAccountPage(),
        );
      case termsConditionsPage:
        return MaterialPageRoute(
          builder: (_) => const TermsPage(),
        );
      case editorPage:
      final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>  EditorPage(noteId: args?['id']),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
