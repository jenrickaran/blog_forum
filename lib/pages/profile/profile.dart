import 'package:flutter/material.dart';
import 'package:flutter_app/providers/post_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_app/services/profile_services.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _imagePicker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? avatarUrl;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = _profileService.currentUser;

      if (user == null) {
        return;
      }

      final profile = await _profileService.getProfile();

      nameController.text = profile?['name'] ?? '';
      emailController.text = user.email ?? '';
      avatarUrl = profile?['profile_photo'];
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        isSaving = true;
      });

      final url = await _profileService.uploadAvatar(image);

      if (mounted) {
        setState(() {
          avatarUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Avatar update error: $e');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update avatar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      setState(() {
        isSaving = true;
      });

      final user = _profileService.currentUser;

      if (user == null) {
        throw Exception('User is not logged in.');
      }

      // Update name
      await _profileService.updateName(nameController.text.trim());

      // Update email
      if (emailController.text.trim() != user.email) {
        await _profileService.updateEmail(emailController.text.trim());
      }

      // Update password only if entered
      if (passwordController.text.isNotEmpty) {
        await _profileService.updatePassword(passwordController.text);
      }

      passwordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Profile update error: $e');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0x000fffff),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                onPressed: () {
                  context.read<PostProvider>().fetchPosts();
                  context.go('/home');
                },
                icon: Image.asset(
                  'assets/images/home_logo.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // AVATAR
                    GestureDetector(
                      onTap: isSaving ? null : _pickAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 55,
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(avatarUrl!)
                                : const AssetImage(
                                    'assets/images/default_avatar.png',
                                  ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/camera_logo.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // NAME
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hoverColor: const Color.fromARGB(255, 20, 37, 67),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF152745),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 2, 12, 29),
                          ),
                        ),
                        labelText: 'Name',
                        labelStyle: const TextStyle(fontFamily: 'Google-Sans'),
                        prefixIcon: Image.asset(
                          'assets/images/user_logo.png',
                          width: 15,
                          height: 15,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hoverColor: const Color.fromARGB(255, 20, 37, 67),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF152745),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 2, 12, 29),
                          ),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontFamily: 'Google-Sans'),
                        prefixIcon: Image.asset(
                          'assets/images/email_logo.png',
                          width: 15,
                          height: 15,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // PASSWORD
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hoverColor: const Color.fromARGB(255, 20, 37, 67),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF152745),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 2, 12, 29),
                          ),
                        ),
                        labelText: 'New Password',
                        labelStyle: TextStyle(fontFamily: 'Google-Sans'),
                        prefixIcon: Image.asset(
                          'assets/images/password_logo.png',
                          width: 15,
                          height: 15,
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Leave blank to keep current password',
                        hintStyle: TextStyle(fontFamily: 'Google-Sans'),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // SAVE BUTTON
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF152745),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: isSaving ? null : _saveProfile,
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(fontFamily: 'Google-Sans'),
                              ),
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
  }
}
