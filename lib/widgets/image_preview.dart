import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreview extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImagePreview({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  static void show(
    BuildContext context, {
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (_) {
        return ImagePreview(imageUrls: imageUrls, initialIndex: initialIndex);
      },
    );
  }

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late int currentIndex;

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    // Automatically focus the viewer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void nextImage() {
    if (currentIndex < widget.imageUrls.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void previousImage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void closePreview() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPrevious = currentIndex > 0;
    final bool hasNext = currentIndex < widget.imageUrls.length - 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (event) {
          if (event is! KeyDownEvent) return;

          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            nextImage();
          }

          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            previousImage();
          }

          if (event.logicalKey == LogicalKeyboardKey.escape) {
            closePreview();
          }
        },
        child: Stack(
          children: [
            // IMAGE
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  widget.imageUrls[currentIndex],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 70,
                    );
                  },
                ),
              ),
            ),

            // CLOSE BUTTON
            Positioned(
              top: 20,
              right: 20,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  onPressed: closePreview,
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                ),
              ),
            ),

            // PREVIOUS ARROW
            if (hasPrevious)
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: previousImage,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // NEXT ARROW
            if (hasNext)
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: nextImage,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // IMAGE COUNTER
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Google-Sans',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
