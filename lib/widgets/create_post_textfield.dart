import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/auth/login_page.dart';
import 'package:flutter_app/pages/post/create_post_page.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CreatePostTextfield extends StatelessWidget {
  const CreatePostTextfield({super.key});

  void _showLoginDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),

            const Center(child: LoginPage()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextField(
        autofocus: true,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFf2f4f7),
          hintText: "Want to share something?",
          hintStyle: TextStyle(fontFamily: 'Google-Sans'),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hoverColor: Colors.transparent,
        ),
        onTap: () {
          if (!authProvider.isLoggedIn) {
            _showLoginDialog(context);
            return;
          }

          showDialog(
            context: context,
            builder: (context) {
              return const CreatePostPage();
            },
          );
        },
      ),
    );
  }
}
