import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/post_provider.dart';
import 'package:flutter_app/widgets/create_post_textfield.dart';
import 'package:flutter_app/widgets/post_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('BLOG FORUM')),

      body: Column(
        children: [
          const CreatePostTextfield(),

          if (postProvider.isLoading && postProvider.posts.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (postProvider.errorMessage != null &&
              postProvider.posts.isEmpty)
            Expanded(child: Center(child: Text(postProvider.errorMessage!)))
          else if (postProvider.posts.isEmpty)
            const Expanded(child: Center(child: Text('No posts yet.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: postProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = postProvider.posts[index];
                  return PostCard(post: post);
                },
              ),
            ),
          ElevatedButton(
            onPressed: () {
              context.go('/profile');
            },
            child: const Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();

              await authProvider.logout();

              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
