import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/auth/widgets/custom_button.dart';
import 'package:formation_flutter/screens/auth/widgets/custom_text_field.dart';
import 'package:formation_flutter/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Spacing from top
              const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
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
              const SizedBox(height: 40),
              CustomButton(
                text: 'Créer un compte',
                onPressed: () {
                  context.push('/register');
                },
              ),
              const SizedBox(height: 16),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return CustomButton(
                    text: 'Se connecter',
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

                      final success = await auth.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              auth.errorMessage ?? 'Erreur de connexion',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
