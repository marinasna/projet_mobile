import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/screens/auth/widgets/custom_button.dart';
import 'package:formation_flutter/screens/auth/widgets/custom_text_field.dart';
import 'package:formation_flutter/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200), // Match LoginPage
              const Center(
                child: Text(
                  'Inscription',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              CustomTextField(
                controller: _emailController,
                hintText: 'Adresse email',
                prefixIcon: SvgPicture.asset('res/svg/ic_email.svg'),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Mot de passe',
                prefixIcon: SvgPicture.asset('res/svg/ic_password.svg'),
                obscureText: true,
              ),
              const SizedBox(height: 48),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return CustomButton(
                    text: 'S\'inscrire',
                    isLoading: auth.isLoading,
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez remplir tous les champs'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final success = await auth.register(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Inscription réussie ! Connexion automatique...',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              auth.errorMessage ?? 'Erreur d\'inscription',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
