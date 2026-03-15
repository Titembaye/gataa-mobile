import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import 'auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthService>();
    final result = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.of(context).pop(true);
    } else if (result.errorMessage != null) {
      _showError(result.errorMessage!);
    }
  }

  Future<void> _loginWithGoogle() async {
    final auth = context.read<AuthService>();
    final result = await auth.loginWithGoogle();

    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.of(context).pop(true);
    } else if (result.errorMessage != null) {
      _showError(result.errorMessage!);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: GataaColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthService>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: SingleChildScrollView(
        padding: GataaSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: GataaSpacing.xl),

              // Titre
              Text('Bon retour !', style: GataaTypo.titleLarge),
              const SizedBox(height: GataaSpacing.sm),
              Text(
                'Connectez-vous pour suivre vos soumissions.',
                style: GataaTypo.bodyMedium.copyWith(
                  color: GataaColors.textSecondary,
                ),
              ),
              const SizedBox(height: GataaSpacing.xxl),

              // Email
              _buildLabel('Email'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'votre@email.com'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Entrez votre email';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: GataaSpacing.lg),

              // Mot de passe
              _buildLabel('Mot de passe'),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: GataaColors.textMuted,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Entrez votre mot de passe';
                  if (v.length < 6) return 'Minimum 6 caractères';
                  return null;
                },
              ),
              const SizedBox(height: GataaSpacing.xxl),

              // Bouton connexion
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GataaColors.textOnDark,
                          ),
                        )
                      : const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: GataaSpacing.md),

              // Séparateur
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GataaSpacing.md,
                    ),
                    child: Text(
                      'ou',
                      style: GataaTypo.labelMedium,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: GataaSpacing.md),

              // Google Sign-In
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : _loginWithGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 22),
                  label: const Text('Continuer avec Google'),
                ),
              ),
              const SizedBox(height: GataaSpacing.xxl),

              // Lien inscription
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pas encore de compte ? ',
                          style: GataaTypo.bodyMedium.copyWith(
                            color: GataaColors.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: 'S\'inscrire',
                          style: GataaTypo.bodyMedium.copyWith(
                            color: GataaColors.navy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GataaSpacing.sm),
      child: Text(text.toUpperCase(), style: GataaTypo.labelSmall),
    );
  }
}