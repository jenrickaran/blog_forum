import 'package:flutter/material.dart';
import 'package:flutter_app/providers/post_provider.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create Post",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
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
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Add Image"),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
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
                  child: const Text("Post"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
