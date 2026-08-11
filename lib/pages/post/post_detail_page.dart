import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/models/post_image.dart';
import 'package:flutter_app/providers/comment_provider.dart';
import 'package:flutter_app/providers/post_provider.dart';
import 'package:flutter_app/widgets/comment_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final commentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _selectedImages = [];
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<XFile> _newImages = [];

  bool _isEditing = false;

  late List<PostImage> _postImages;

  @override
  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.post.title);

    _contentController = TextEditingController(text: widget.post.content);

    _postImages = List.from(widget.post.imageUrls);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final commentProvider = context.read<CommentProvider>();

      await commentProvider.loadComments(widget.post.id);
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();

    setState(() {
      _selectedImages = images;
    });
  }

  Future<void> _updatePost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty.')));
      return;
    }

    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Content cannot be empty.')));
      return;
    }

    final postProvider = context.read<PostProvider>();

    final success = await postProvider.updatePost(
      postId: widget.post.id,
      title: title,
      content: content,
      remainingImages: _postImages,
      newImages: _newImages,
    );

    if (!context.mounted) return;

    if (success) {
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(postProvider.errorMessage ?? 'Failed to update post.'),
        ),
      );
    }
  }

  Future<void> _pickPostImages() async {
    final images = await _imagePicker.pickMultiImage();

    if (images.isEmpty) return;

    setState(() {
      _newImages.addAll(images);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _postImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    final bool isOwner =
        currentUser != null && currentUser.id == widget.post.userId;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Post Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isOwner) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_isEditing) {
                                _titleController.text = widget.post.title;
                                _contentController.text = widget.post.content;

                                setState(() {
                                  _isEditing = false;
                                });
                              } else {
                                setState(() {
                                  _isEditing = true;
                                });
                              }
                            },
                            icon: Icon(_isEditing ? Icons.close : Icons.edit),
                          ),

                          // SAVE
                          if (_isEditing)
                            IconButton(
                              onPressed: _updatePost,
                              icon: const Icon(Icons.save, color: Colors.green),
                            ),

                          // DELETE
                          if (!_isEditing)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final postProvider = context
                                    .read<PostProvider>();

                                final success = await postProvider.deletePost(
                                  widget.post.id,
                                );

                                if (!context.mounted) return;

                                if (success) {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Post deleted successfully.',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        postProvider.errorMessage ??
                                            'You are not authorized to delete this post.',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    _isEditing
                        ? TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            widget.post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 10),
                    _isEditing
                        ? TextField(
                            controller: _contentController,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              labelText: 'Content',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            widget.post.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                    if (_isEditing)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Post Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // EXISTING IMAGES
                          if (_postImages.isNotEmpty)
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _postImages.length,
                                itemBuilder: (context, index) {
                                  final image = _postImages[index];

                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            image.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // REMOVE EXISTING IMAGE
                                      Positioned(
                                        top: 0,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            _removeExistingImage(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                          const SizedBox(height: 10),

                          // NEW IMAGES
                          if (_newImages.isNotEmpty)
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _newImages.length,
                                itemBuilder: (context, index) {
                                  final image = _newImages[index];
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            image.path,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // REMOVE NEW IMAGE
                                      Positioned(
                                        top: 0,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            _removeNewImage(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                          const SizedBox(height: 10),

                          // ADD IMAGE BUTTON
                          OutlinedButton.icon(
                            onPressed: _pickPostImages,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Images'),
                          ),
                        ],
                      )
                    else if (widget.post.imageUrls.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: widget.post.imageUrls.length,
                          itemBuilder: (context, index) {
                            final image = widget.post.imageUrls[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  image.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text('Unable to load image'),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                    CommentList(),
                    /*Expanded(child: CommentList()),*/
                  ],
                ),
              ),
            ),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _selectedImages[index].path,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _pickImages,
                    icon: Icon(Icons.add_a_photo),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final CommentProvider commentProvider =
                          Provider.of<CommentProvider>(context, listen: false);
                      final success = await commentProvider.createComment(
                        postId: widget.post.id,
                        content: commentController.text,
                        images: _selectedImages,
                      );
                      if (success) {
                        commentController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comment added successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add comment.'),
                          ),
                        );
                      }
                    },
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
