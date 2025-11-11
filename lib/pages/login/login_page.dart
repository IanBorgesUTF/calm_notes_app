
import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/services/login/login_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget 
{
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final LoginService loginService = LoginService();

  bool obscure = true;
  bool submitting = false;

  

  

void submit() async {
  final valid = formKey.currentState?.validate() ?? false;
  if (!valid) return;

  setState(() => submitting = true);

  final error = await loginService.login(
    emailCtrl.text.trim(),
    passCtrl.text,
  );

  setState(() => submitting = false);

  if (error != null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
    return;
  }
  if (!mounted) return;
  Navigator.of(context).pushReplacementNamed(Routes.homePage);
}


  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 128),
                child: Icon(Icons.note_alt, size: 40, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('CalmNotes', style: TextStyle(fontSize: 24, color: Colors.white)),
              const SizedBox(height: 24),

              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: loginService.validateEmail,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passCtrl,
                      obscureText: obscure,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(color: Colors.white),
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: loginService.validatePassword,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: loginService.buildPasswordRules(passCtrl.text)),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitting ? null : submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue,
                        ),
                        child: submitting
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Entrar', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recuperação de senha (não implementada)')));
                          },
                          child: const Text('Esqueceu a senha?'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.termsConditionsPage);
                          },
                          child: const Text('Criar conta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
