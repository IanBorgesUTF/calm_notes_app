import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:calm_notes_app/features/theme/presentation/providers/theme_provider.dart';
import 'package:calm_notes_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final Validators validators = Validators();

  bool obscure = true;
  bool submitting = false;

  void submit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => submitting = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    setState(() => submitting = false);

    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Erro')),
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
    final colors = theme.colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'), 
        centerTitle: true, 
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.nightlight_round : Icons.wb_sunny,
              color: colors.onSurfaceVariant,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
               backgroundColor: theme.colorScheme.primary.withValues(alpha: 128),
                child: Icon(Icons.person_add, size: 40, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('CalmNotes',
                  style: TextStyle(
                    fontSize: 24,
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 24),

              Form(
                
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.email, color: colors.onSurfaceVariant),
                        floatingLabelStyle: TextStyle(color: colors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: validators.email,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: passCtrl,
                      obscureText: obscure,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.lock, color: colors.onSurfaceVariant),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                            color: colors.onSurfaceVariant,
                          ),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                        floatingLabelStyle: TextStyle(color: colors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: validators.password,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),

                     Align(alignment: Alignment.centerLeft, child: validators.buildPasswordRules(passCtrl.text, context)),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitting ? null : submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                        ),
                        child: submitting
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Recuperação de senha (não implementada)')),
                            );
                          },
                          child: Text('Esqueceu a senha?', style: TextStyle(color: colors.primary)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.termsConditionsPage);
                          },
                          child: Text('Criar conta', style: TextStyle(color: colors.primary)),
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
