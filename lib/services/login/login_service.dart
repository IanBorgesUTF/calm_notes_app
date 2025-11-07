import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {

  final supabase = Supabase.instance.client;

   Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return 'Falha no login: usuário não encontrado.';
      }

      if (user.emailConfirmedAt == null) {
        return 'Confirme seu email antes de entrar.';
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }


  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email é obrigatório.';
    final email = value.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) return 'Email inválido. Deve conter "@" e domínio.';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória.';
    if (value.length < 8) return 'Senha deve ter pelo menos 8 caracteres.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Inclua ao menos 1 letra maiúscula.';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Inclua ao menos 1 letra minúscula.';
    if (!RegExp(r'\d').hasMatch(value)) return 'Inclua ao menos 1 número.';
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) return 'Inclua ao menos 1 caractere especial.';
    return null;
  }

    Widget buildPasswordRules(String value) {
    final rules = <Map<String, bool>>[
      {'8+ caracteres': value.length >= 8},
      {'Maiúscula (A-Z)': RegExp(r'[A-Z]').hasMatch(value)},
      {'Minúscula (a-z)': RegExp(r'[a-z]').hasMatch(value)},
      {'Número (0-9)': RegExp(r'\d').hasMatch(value)},
      {'Especial (!@#...)': RegExp(r'[^A-Za-z0-9]').hasMatch(value)},
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: rules.map((r) {
        final text = r.keys.first;
        final ok = r.values.first;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.cancel,
              size: 14,
              color: ok ? Colors.green : Colors.redAccent,
            ),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(color: Colors.white),),
          ],
        );
      }).toList(),
    );
  }

  
}
