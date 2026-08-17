import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/post_provider.dart';
import 'package:flutter_app/widgets/auth_dialog.dart';
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
  Future<void> _refreshPosts() async {
    final postProvider = context.read<PostProvider>();

    try {
      await postProvider.fetchPosts();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshPosts();
      }
    });
  }

  Future<void> _logout() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.logout();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Log Out')));
      context.go('/home');
    }
  }

  Widget _navigation(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Column(
      children: [
        if (authProvider.isLoggedIn) ...[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                const Text(
                  'BLOG FORUM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Google-Sans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Profile
          ListTile(
            leading: Image.asset(
              'assets/images/profile_logo.png',
              width: 24,
              height: 24,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(fontFamily: 'Google-Sans'),
            ),
            onTap: () {
              context.go('/profile');
            },
          ),
          // Logout
          ListTile(
            leading: Image.asset(
              'assets/images/logout_logo.png',
              width: 24,
              height: 24,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Google-Sans'),
            ),
            onTap: _logout,
          ),
        ] else ...[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                const Text(
                  'BLOG FORUM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Google-Sans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Profile
          ListTile(
            leading: Image.asset(
              'assets/images/profile_logo.png',
              width: 24,
              height: 24,
            ),
            title: const Text(
              'Login',
              style: TextStyle(fontFamily: 'Google-Sans'),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AuthDialog();
                },
              );
            },
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;
        return Scaffold(
          backgroundColor: Color(0x000fffff),
          // Drawer exists only on mobile
          drawer: isMobile
              ? Drawer(child: SafeArea(child: _navigation(context)))
              : null,

          body: Row(
            children: [
              // DESKTOP SIDEBAR
              if (!isMobile)
                SizedBox(
                  width: 240,
                  child: SafeArea(child: _navigation(context)),
                ),

              // MAIN CONTENT
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      children: [
                        // MOBILE MENU BUTTON
                        if (isMobile)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: Image.asset(
                                    'assets/images/menu_logo.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                );
                              },
                            ),
                          ),

                        // EVERYTHING BELOW SCROLLS TOGETHER
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              const SizedBox(height: 30),

                              // CREATE POST
                              const CreatePostTextfield(),
                              const SizedBox(height: 10),
                              // LOADING
                              if (postProvider.isLoading &&
                                  postProvider.posts.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              // ERROR
                              else if (postProvider.errorMessage != null &&
                                  postProvider.posts.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Text(postProvider.errorMessage!),
                                  ),
                                )
                              // NO POSTS
                              else if (postProvider.posts.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Text('No posts yet.'),
                                  ),
                                )
                              // POSTS
                              else
                                ...postProvider.posts.map(
                                  (post) => Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: PostCard(post: post),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
