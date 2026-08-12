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
          hoverColor: const Color.fromARGB(255, 20, 37, 67),
          floatingLabelStyle: const TextStyle(color: Color(0xFF152745)),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 2, 12, 29)),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}
