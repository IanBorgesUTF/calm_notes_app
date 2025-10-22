import 'package:calm_notes_app/pages/Terms/terms.dart';
import 'package:calm_notes_app/pages/editor/editor.dart';
import 'package:calm_notes_app/pages/home/home.dart';
import 'package:calm_notes_app/pages/onboarding/onboarding_page.dart';
import 'package:calm_notes_app/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String splashScreen = '/';
  static const String homePage = '/home_page';
  static const String termsConditionsPage = '/terms_page';
  static const String editorPage = '/editor_page';
  static const String onboardingPage = '/onboarding_page';

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
      case termsConditionsPage:
        return MaterialPageRoute(
          builder: (_) => const TermsPage(),
        );
      case editorPage:
      final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          
          builder: (_) =>  EditorPage(noteId: args?['id']),
        );
      case onboardingPage:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
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
