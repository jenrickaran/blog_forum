import 'package:flutter/material.dart';

class SnackbarComment extends StatelessWidget {
  final String message;
  const SnackbarComment({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
