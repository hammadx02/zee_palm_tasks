// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:zee_palm_tasks/providers/auth_provider.dart';
// import 'package:zee_palm_tasks/screens/login_screen.dart';
// import 'package:zee_palm_tasks/widgets/auth_field.dart';
// import 'package:zee_palm_tasks/widgets/auth_gradient_button.dart';

// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> signUp() async {
//     if (!formKey.currentState!.validate()) return;
//     if (passwordController.text != confirmPasswordController.text) {
//       Fluttertoast.showToast(msg: 'Passwords do not match');
//       return;
//     }

//     setState(() => isLoading = true);

//     final result = await ref
//         .read(authRepositoryProvider)
//         .signUpWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//     setState(() => isLoading = false);

//     result.fold(
//       (failure) => Fluttertoast.showToast(
//         msg: failure.toString(),
//         toastLength: Toast.LENGTH_LONG,
//       ),
//       (user) => Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Create Account',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 30),
//               AuthField(controller: emailController, hintText: 'Email'),
//               const SizedBox(height: 20),
//               AuthField(
//                 controller: passwordController,
//                 hintText: 'Password',
//                 isObscure: true,
//               ),
//               const SizedBox(height: 20),
//               AuthField(
//                 controller: confirmPasswordController,
//                 hintText: 'Confirm Password',
//                 isObscure: true,
//               ),
//               const SizedBox(height: 30),
//               AuthGradientButton(
//                 text: 'Sign Up',
//                 onPressed: isLoading ? null : () => signUp(),

//                 // onPressed: () {
//                 //   isLoading ? null : () => signUp();
//                 // },
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap:
//                     isLoading
//                         ? null
//                         : () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                 child: RichText(
//                   text: const TextSpan(
//                     text: 'Already have an account? ',
//                     style: TextStyle(color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: 'Sign In',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isLoading) ...[
//                 const SizedBox(height: 20),
//                 const CircularProgressIndicator(),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zee_palm_tasks/features/auth/presentation/auth_provider.dart';
import 'package:zee_palm_tasks/features/auth/presentation/screens/login_screen.dart';
import 'package:zee_palm_tasks/features/auth/presentation/widgets/auth_field.dart';
import 'package:zee_palm_tasks/features/auth/presentation/widgets/auth_gradient_button.dart';

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
      Fluttertoast.showToast(
        msg: 'Passwords do not match',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
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
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerLowest,
                      Theme.of(context).colorScheme.surfaceContainerLow,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 8),
                      Text(
                        'Join ZeePalm to share videos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      const SizedBox(height: 32),
                      AuthField(
                        controller: emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ).animate().slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ),
                      const SizedBox(height: 16),
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        isObscure: true,
                        keyboardType: TextInputType.visiblePassword,
                      ).animate().slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                        delay: 50.ms,
                      ),
                      const SizedBox(height: 16),
                      AuthField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        isObscure: true,
                        keyboardType: TextInputType.visiblePassword,
                      ).animate().slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                        delay: 100.ms,
                      ),
                      const SizedBox(height: 24),
                      AuthGradientButton(
                        text: 'Sign Up',
                        onPressed: isLoading ? null : () => signUp(),
                      ).animate().scale(
                        duration: 200.ms,
                        curve: Curves.easeOut,
                      ),
                      const SizedBox(height: 16),
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
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                      if (isLoading) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 3,
                          ),
                        ).animate().fadeIn(duration: 200.ms),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
