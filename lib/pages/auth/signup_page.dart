import 'package:flutter/material.dart';
import 'package:flutter_app/pages/auth/login_page.dart';
import 'package:flutter_app/widgets/blue_elevated_button.dart';
import 'package:flutter_app/widgets/textfield.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback? onLogin;
  const SignupPage({super.key, this.onLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;

  Future<void> signup() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text,
      );

      if (success && mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
            SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/vectorimage.png',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: const Text(
                      'CREATE YOUR ACCOUNT',
                      style: TextStyle(
                        color: Color(0xFF152745),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Google-Sans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextFields(
                      controller: _emailController,
                      labelText: "Email",
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextFields(
                      controller: _passwordController,
                      labelText: "Password",
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextFields(
                      controller: _nameController,
                      labelText: "Name",
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 400,
                    child: BlueElevatedButton(
                      onTap: () async {
                        final success = await authProvider.signUp(
                          _emailController.text.trim(),
                          _passwordController.text,
                          _nameController.text.trim(),
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Sign Up Successful! Please log in.',
                              ),
                            ),
                          );
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController.clear();
                        }
                      },
                      text: "Sign Up",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Row(
                      children: [
                        Text(
                          "Alredy have an account?",
                          style: TextStyle(fontFamily: 'Google-Sans'),
                        ),
                        TextButton(
                          onPressed: widget.onLogin,
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: const Icon(Icons.close, size: 28, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
