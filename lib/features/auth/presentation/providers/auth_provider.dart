import 'package:calm_notes_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes_app/features/auth/domain/usecases/create_account_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final CreateAccountUseCase createAccountUseCase;
  bool loading = false;
  String? error;

  AuthProvider({required this.loginUseCase,required this.createAccountUseCase});

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await createAccountUseCase.call(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> login({ required String email, required String password }) async {
    loading = true;
    notifyListeners();
    try {
      await loginUseCase.call(email: email, password: password);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}