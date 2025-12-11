import 'package:calm_notes_app/config/routes.dart';
import 'package:calm_notes_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:calm_notes_app/features/theme/presentation/providers/theme_provider.dart';
import 'package:calm_notes_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  static const routeName = '/create-account';

  @override
  State<CreateAccountPage> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final Validators validators = Validators();

  bool obscurePass = true;
  bool obscureConfirm = true;
  bool submitting = false;

  String? confirmValidator(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a senha.';
    if (value != passCtrl.text) return 'Senhas não coincidem.';
    return null;
  }

  void submit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => submitting = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.createAccount(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta criada com sucesso!')),
    );
    Navigator.of(context).pushReplacementNamed(Routes.loginPage);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    phoneCtrl.dispose();
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
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 128),
                child: Icon(Icons.person_add, size: 40, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'Bem-vindo(a) ao CalmNotes',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.person, color: colors.onSurfaceVariant),
                        floatingLabelStyle: TextStyle(color: colors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: validators.name,
                    ),
                    const SizedBox(height: 12),

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
                      obscureText: obscurePass,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.lock, color: colors.onSurfaceVariant),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePass ? Icons.visibility : Icons.visibility_off,
                            color: colors.onSurfaceVariant,
                          ),
                          onPressed: () => setState(() => obscurePass = !obscurePass),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: validators.password,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),

                     Align(alignment: Alignment.centerLeft, child: validators.buildPasswordRules(passCtrl.text,context)),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: confirmCtrl,
                      obscureText: obscureConfirm,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.lock_outline, color: colors.onSurfaceVariant),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm ? Icons.visibility : Icons.visibility_off,
                            color: colors.onSurfaceVariant,
                          ),
                          onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                        ),
                        floatingLabelStyle: TextStyle(color: colors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: confirmValidator,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        labelStyle: TextStyle(color: colors.onSurfaceVariant),
                        hintText: 'Ex: +5511999887777',
                        hintStyle: TextStyle(color: colors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.phone, color: colors.onSurfaceVariant),
                        floatingLabelStyle: TextStyle(color: colors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: validators.phone,
                    ),
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
                            : const Text('Criar conta'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.loginPage),
                      child: Text('Já tem uma conta? Entrar', style: TextStyle(color: colors.primary)),
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
