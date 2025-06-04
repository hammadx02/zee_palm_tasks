// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:zee_palm_tasks/providers/auth_provider.dart';
// // import 'package:zee_palm_tasks/screens/sign_up_screen.dart';
// // import 'package:zee_palm_tasks/screens/video_feed_screen.dart';

// // import 'package:zee_palm_tasks/widgets/auth_field.dart';
// // import 'package:zee_palm_tasks/widgets/auth_gradient_button.dart';

// // class LoginScreen extends ConsumerStatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends ConsumerState<LoginScreen> {
// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   final formKey = GlobalKey<FormState>();
// //   bool isLoading = false;

// //   @override
// //   void dispose() {
// //     emailController.dispose();
// //     passwordController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> signIn() async {
// //     if (!formKey.currentState!.validate()) return;

// //     setState(() => isLoading = true);

// //     final result = await ref
// //         .read(authRepositoryProvider)
// //         .signInWithEmailAndPassword(
// //           email: emailController.text.trim(),
// //           password: passwordController.text.trim(),
// //         );

// //     setState(() => isLoading = false);

// //     result.fold(
// //       (failure) => Fluttertoast.showToast(
// //         msg: failure.toString(),
// //         toastLength: Toast.LENGTH_LONG,
// //       ),
// //       (user) => Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => const VideoFeedScreen()),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Form(
// //           key: formKey,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Text(
// //                 'ZeePalm Video App',
// //                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 30),
// //               AuthField(controller: emailController, hintText: 'Email'),
// //               const SizedBox(height: 20),
// //               AuthField(
// //                 controller: passwordController,
// //                 hintText: 'Password',
// //                 isObscure: true,
// //               ),
// //               const SizedBox(height: 30),
// //               AuthGradientButton(
// //                 text: 'Sign In',
// //                 onPressed: isLoading ? null : () => signIn(),
// //               ),
// //               const SizedBox(height: 20),
// //               GestureDetector(
// //                 onTap:
// //                     isLoading
// //                         ? null
// //                         : () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const SignUpScreen(),
// //                             ),
// //                           );
// //                         },
// //                 child: RichText(
// //                   text: const TextSpan(
// //                     text: 'Don\'t have an account? ',
// //                     style: TextStyle(color: Colors.black),
// //                     children: [
// //                       TextSpan(
// //                         text: 'Sign Up',
// //                         style: TextStyle(
// //                           color: Colors.blue,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               if (isLoading) ...[
// //                 const SizedBox(height: 20),
// //                 const CircularProgressIndicator(),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:zee_palm_tasks/providers/auth_provider.dart';
// import 'package:zee_palm_tasks/screens/sign_up_screen.dart';
// import 'package:zee_palm_tasks/screens/video_feed_screen.dart';
// import 'package:zee_palm_tasks/widgets/auth_field.dart';
// import 'package:zee_palm_tasks/widgets/auth_gradient_button.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> signIn() async {
//     if (!formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     final result = await ref
//         .read(authRepositoryProvider)
//         .signInWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//     setState(() => isLoading = false);

//     result.fold(
//       (failure) => Fluttertoast.showToast(
//         msg: failure.toString(),
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Theme.of(context).colorScheme.error,
//         textColor: Theme.of(context).colorScheme.onError,
//       ),
//       (user) => Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const VideoFeedScreen()),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'ZeePalm Video App',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                 ).animate().fadeIn(duration: 300.ms),
//                 const SizedBox(height: 48),
//                 AuthField(
//                   controller: emailController,
//                   hintText: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                 ).animate().slideY(
//                       begin: 0.1,
//                       end: 0,
//                       duration: 300.ms,
//                       curve: Curves.easeOut,
//                     ),
//                 const SizedBox(height: 16),
//                 AuthField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   isObscure: true,
//                   keyboardType: TextInputType.visiblePassword,
//                 ).animate().slideY(
//                       begin: 0.1,
//                       end: 0,
//                       duration: 300.ms,
//                       curve: Curves.easeOut,
//                     ),
//                 const SizedBox(height: 24),
//                 AuthGradientButton(
//                   text: 'Sign In',
//                   onPressed: isLoading ? null : () => signIn(),
//                 ).animate().scale(duration: 200.ms, curve: Curves.easeOut),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: isLoading
//                       ? null
//                       : () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SignUpScreen(),
//                             ),
//                           );
//                         },
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Don't have an account? ",
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color: Theme.of(context).colorScheme.onSurfaceVariant,
//                           ),
//                       children: [
//                         TextSpan(
//                           text: 'Sign Up',
//                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ).animate().fadeIn(duration: 300.ms),
//                 if (isLoading) ...[
//                   const SizedBox(height: 24),
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ).animate().fadeIn(duration: 200.ms),
//                 ],
//               ],
//             ),
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
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
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
                        'Welcome to ZeePalm',
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
                        'Sign in to explore videos',
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
                      const SizedBox(height: 24),
                      AuthGradientButton(
                        text: 'Sign In',
                        onPressed: isLoading ? null : () => signIn(),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignUpScreen(),
                                    ),
                                  );
                                },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Don't have an account? ",
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
                                text: 'Sign Up',
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
