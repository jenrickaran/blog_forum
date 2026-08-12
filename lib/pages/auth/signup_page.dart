import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/orange_elevated_button.dart';
import 'package:flutter_app/widgets/textfield.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _nameController = TextEditingController();

class _SignupPageState extends State<SignupPage> {
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: CustomTextFields(
                controller: _emailController,
                labelText: "Email",
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: CustomTextFields(
                controller: _passwordController,
                labelText: "Password",
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: CustomTextFields(
                controller: _nameController,
                labelText: "Name",
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: 400,
              child: OrangeElevatedButton(
                onTap: () async {
                  final success = await authProvider.signUp(
                    _emailController.text.trim(),
                    _passwordController.text,
                    _nameController.text.trim(),
                  );

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign Up Successful! Please log in.'),
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
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontFamily: 'Google-Sans'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
