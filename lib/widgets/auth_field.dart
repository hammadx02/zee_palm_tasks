// import 'package:flutter/material.dart';

// class AuthField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool isObscure;

//   const AuthField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.isObscure = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isObscure,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $hintText';
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         hintText: hintText,
//         contentPadding: const EdgeInsets.all(20),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(width: 1, color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(width: 1, color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final TextInputType? keyboardType;

  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
