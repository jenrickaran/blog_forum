import 'package:flutter/material.dart';

class BlueElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  const BlueElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF152745),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      child: Text(text, style: TextStyle(fontFamily: 'Google-Sans')),
    );
  }
}
