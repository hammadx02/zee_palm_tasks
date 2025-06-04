import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zee_palm_tasks/providers/auth_provider.dart';
import 'package:zee_palm_tasks/screens/sign_up_screen.dart';
import 'package:zee_palm_tasks/screens/video_feed_screen.dart';

import 'package:zee_palm_tasks/widgets/auth_field.dart';
import 'package:zee_palm_tasks/widgets/auth_gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(
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
        MaterialPageRoute(builder: (context) => const VideoFeedScreen()),
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
                'ZeePalm Video App',
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
              const SizedBox(height: 30),
              AuthGradientButton(
                text: 'Sign In',
                onPressed: isLoading ? null : () => signIn(),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    isLoading
                        ? null
                        : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                child: RichText(
                  text: const TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
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
