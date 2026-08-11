import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
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
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            spacing: 20,
            children: [
              Image.asset('assets/images/vector1.png', width: 600, height: 300),
              const Text(
                'Log In',
                style: TextStyle(
                  color: Color(0xFFFF5F00),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Google-Sans',
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hoverColor: Color(0xFFFF5F00),
                    floatingLabelStyle: TextStyle(color: Color(0xFFFF5F00)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF5F00)),
                    ),
                    labelText: 'Username or Email',
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hoverColor: Color(0xFFFF5F00),
                    floatingLabelStyle: TextStyle(color: Color(0xFFFF5F00)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF5F00)),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final sucess = await authProvider.login(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );

                      if (sucess && context.mounted) {
                        context.go('/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5F00),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text('Log In'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
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
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF8C00),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
