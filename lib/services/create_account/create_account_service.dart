import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccountService {
  final supabase = Supabase.instance.client;

  Future<String?> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
  final result = await supabase.auth.signUp(
    email: email,
    password: password,
  );

  final userId = result.user!.id;

  await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );

  await supabase.from('user').insert({
    'id': userId,
    'name': name,
    'email': email,
    'phone_number': phone,
  }); 

  return null;
} catch (e) {
  return e.toString();
}
  }

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nome é obrigatório.';
    
    return null;
  }

    String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email é obrigatório.';
    final email = value.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) return 'Email inválido.';
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória.';
    final pass = value;
    if (pass.length < 8) return 'Senha deve ter pelo menos 8 caracteres.';
    if (!RegExp(r'[A-Z]').hasMatch(pass)) return 'Inclua ao menos 1 letra maiúscula.';
    if (!RegExp(r'[a-z]').hasMatch(pass)) return 'Inclua ao menos 1 letra minúscula.';
    if (!RegExp(r'\d').hasMatch(pass)) return 'Inclua ao menos 1 número.';
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) return 'Inclua ao menos 1 caractere especial.';
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Telefone é obrigatório.';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\.\(\)+]'), '');
    if (!RegExp(r'^\d{8,15}$').hasMatch(cleaned)) return 'Telefone inválido (8–15 dígitos).';
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
      spacing: 10,
      runSpacing: 6,
      children: rules.map((r) {
        final text = r.keys.first;
        final ok = r.values.first;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ok ? Icons.check_circle : Icons.cancel,
                size: 14, color: ok ? Colors.green : Colors.redAccent),
            const SizedBox(width: 6),
            Text(text, style:TextStyle(color: Colors.white) ),
          ],
        );
      }).toList(),
    );
  }
 
  
}
