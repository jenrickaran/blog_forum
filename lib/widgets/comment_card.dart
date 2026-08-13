import 'package:flutter/material.dart';
import 'package:flutter_app/models/comment.dart';
import 'package:flutter_app/models/comment_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final bool isOwner;
  final Future<void> Function(String, List<CommentImage>, List<XFile>)? onEdit;
  final VoidCallback? onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    this.isOwner = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late TextEditingController _contentController;
  bool _isEditing = false;
  late List<CommentImage> _commentImages;
  final List<XFile> _newImages = [];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.comment.content);
    _commentImages = List.from(widget.comment.commentImages);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _showImagePreview(int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.85,
                child: PageView.builder(
                  controller: PageController(initialPage: initialIndex),
                  itemCount: _commentImages.length,
                  itemBuilder: (context, index) {
                    final image = _commentImages[index];

                    return InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Center(
                        child: Image.network(
                          image.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Unable to load image',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 235, 237, 239),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      widget.comment.profilePhoto != null &&
                          widget.comment.profilePhoto!.isNotEmpty
                      ? NetworkImage(widget.comment.profilePhoto!)
                      : const AssetImage('assets/images/default_avatar.png'),
                ),

                const SizedBox(width: 8),

                Text(
                  widget.comment.userName ?? 'Unknown User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Google-Sans',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            _isEditing
                ? TextField(
                    controller: _contentController,
                    maxLines: null,
                    autofocus: true,
                  )
                : Text(
                    widget.comment.content,
                    style: TextStyle(fontFamily: 'Google-Sans'),
                  ),

            const SizedBox(height: 8),

            if (widget.comment.commentImages.isNotEmpty) ...[
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commentImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final image = entry.value;

                  return Stack(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (!_isEditing) {
                              _showImagePreview(index);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      if (_isEditing)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _commentImages.remove(image);
                              });
                            },
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 10),

            Text(
              DateFormat(
                'MMM dd, yyyy • hh:mm a',
              ).format(widget.comment.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Google-Sans',
              ),
            ),

            if (widget.isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    IconButton(
                      icon: Image.asset(
                        'assets/images/check_logo.png',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () async {
                        await widget.onEdit?.call(
                          _contentController.text.trim(),
                          _commentImages,
                          _newImages,
                        );

                        if (!mounted) return;
                      },
                    )
                  else
                    IconButton(
                      icon: Image.asset(
                        'assets/images/edit_logo.png',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/trash_logo.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
