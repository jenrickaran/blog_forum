import 'package:flutter/material.dart';

class OrangeElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  const OrangeElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF5F00),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      child: Text(text, style: TextStyle(fontFamily: 'Google-Sans')),
    );
  }
}
