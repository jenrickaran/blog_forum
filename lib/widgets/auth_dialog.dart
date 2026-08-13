import 'package:flutter/material.dart';
import 'package:flutter_app/pages/auth/login_page.dart';
import 'package:flutter_app/pages/auth/signup_page.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool isLogin = true;

  void showLogin() {
    setState(() {
      isLogin = true;
    });
  }

  void showSignup() {
    setState(() {
      isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: Stack(
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  offset: isLogin ? Offset.zero : const Offset(-1, 0),
                  child: IgnorePointer(
                    ignoring: !isLogin,
                    child: LoginPage(onSignup: showSignup),
                  ),
                ),

                AnimatedSlide(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  offset: isLogin ? const Offset(1, 0) : Offset.zero,
                  child: IgnorePointer(
                    ignoring: isLogin,
                    child: SignupPage(onLogin: showLogin),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
