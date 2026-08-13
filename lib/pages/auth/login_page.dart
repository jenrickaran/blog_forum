import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/widgets/blue_elevated_button.dart';
import 'package:flutter_app/widgets/textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Dialog(
      backgroundColor: Color(0xFFf0f4f9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Stack(
          children: [
            Center(
              child: Column(
                spacing: 20,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/vector1.png',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: const Text(
                      'SIGN IN TO YOUR ACCOUNT',
                      style: TextStyle(
                        color: Color(0xFF152745),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Google-Sans',
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomTextFields(
                      controller: _emailController,
                      labelText: "Email",
                      obscureText: false,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomTextFields(
                      controller: _passwordController,
                      labelText: "Password",
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 400,
                    child: BlueElevatedButton(
                      onTap: () async {
                        final sucess = await authProvider.login(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );

                        if (sucess && context.mounted) {
                          context.pop();
                          context.go('/home');
                        }
                      },
                      text: "Sign In",
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Row(
                      children: [
                        Text(
                          "New here?",
                          style: TextStyle(fontFamily: 'Google-Sans'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: const Text(
                            'Signup',
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    context.pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: Color(0xFF152745),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
