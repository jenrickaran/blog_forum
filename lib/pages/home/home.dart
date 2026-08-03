import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/widgets/create_post_textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLOG FORUM')),
      body: Center(
        child: Column(
          children: [
            CreatePostTextfield(),
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontFamily: 'Google-Sans'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
