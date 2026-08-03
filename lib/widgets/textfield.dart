import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hoverColor: const Color(0xFFFF5F00),
          floatingLabelStyle: const TextStyle(color: Color(0xFFFF5F00)),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF5F00)),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}
