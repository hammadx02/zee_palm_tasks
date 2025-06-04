import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zee_palm_tasks/providers/auth_provider.dart';
import 'package:zee_palm_tasks/screens/login_screen.dart';
import 'package:zee_palm_tasks/widgets/auth_field.dart';
import 'package:zee_palm_tasks/widgets/auth_gradient_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    final result = await ref
        .read(authRepositoryProvider)
        .signUpWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    setState(() => isLoading = false);

    result.fold(
      (failure) => Fluttertoast.showToast(
        msg: failure.toString(),
        toastLength: Toast.LENGTH_LONG,
      ),
      (user) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              AuthField(controller: emailController, hintText: 'Email'),
              const SizedBox(height: 20),
              AuthField(
                controller: passwordController,
                hintText: 'Password',
                isObscure: true,
              ),
              const SizedBox(height: 20),
              AuthField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                isObscure: true,
              ),
              const SizedBox(height: 30),
              AuthGradientButton(
                text: 'Sign Up',
                onPressed: () {
                  isLoading ? null : () => signUp;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    isLoading
                        ? null
                        : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
