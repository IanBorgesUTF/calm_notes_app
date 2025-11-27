import 'dart:async';

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


    

  
}
