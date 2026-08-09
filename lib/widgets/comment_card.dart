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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.comment.content),
            _isEditing
                ? TextField(
                    controller: _contentController,
                    maxLines: null,
                    autofocus: true,
                  )
                : Text(widget.comment.content),

            const SizedBox(height: 8),

            Text(widget.comment.content),

            if (widget.comment.commentImages.isNotEmpty) ...[
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commentImages.map((image) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
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
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            if (widget.isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    IconButton(
                      icon: const Icon(Icons.check),
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
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete),
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
