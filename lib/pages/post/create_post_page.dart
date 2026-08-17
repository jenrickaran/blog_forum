import 'package:flutter/material.dart';
import 'package:flutter_app/providers/post_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<XFile> _selectedImage = [];
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Post",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Google-Sans',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(fontFamily: 'Google-Sans'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF152745)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _contentController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(fontFamily: 'Google-Sans'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF152745)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                              _selectedImage.first.path,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_selectedImage.first.path),
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon: Image.asset(
                      'assets/images/add_image_logo.png',
                      width: 20,
                      height: 20,
                    ),
                    label: const Text(
                      "Add Image",
                      style: TextStyle(
                        fontFamily: 'Google-Sans',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    onPressed: () async {
                      final List<XFile> image = await ImagePicker()
                          .pickMultiImage();
                      if (image.isNotEmpty) {
                        setState(() {
                          _selectedImage.addAll(image);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF152745),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () async {
                        final PostProvider postProvider = PostProvider();
                        await postProvider.createPost(
                          title: _titleController.text,
                          content: _contentController.text,
                          images: _selectedImage,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              postProvider.errorMessage ??
                                  'Post created successfully!',
                            ),
                          ),
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(fontFamily: 'Google-Sans'),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
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
      ),
    );
  }
}
