import 'package:calm_notes_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> setSeenFlag() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('seen_welcome_v1', true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CalmNotes'),
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              Text(
                'Bem-vindo ao CalmNotes',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,        // ← usa cor do tema
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Escreva suas notas, elas ficam locais por padrão. '
                'Leia nossos Termos e Condições antes de continuar.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                  child: const Text('Começar com minhas anotações'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
