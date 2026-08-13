import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/pages/auth/login_page.dart';
import 'package:flutter_app/pages/post/post_detail_page.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/widgets/auth_dialog.dart';
import 'package:flutter_app/widgets/image_preview.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFf2f4f7),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Google-Sans',
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      post.profilePhoto != null && post.profilePhoto!.isNotEmpty
                      ? NetworkImage(post.profilePhoto!)
                      : const AssetImage('assets/images/default_avatar.png'),
                ),

                const SizedBox(width: 8),

                Text(
                  post.userName ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Google-Sans',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              post.content,
              style: const TextStyle(fontFamily: 'Google-Sans'),
            ),
            const SizedBox(height: 10),
            if (post.imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imageUrls.length,
                  itemBuilder: (context, index) {
                    final image = post.imageUrls[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            ImagePreview.show(
                              context,
                              imageUrls: post.imageUrls
                                  .map((image) => image.imageUrl)
                                  .toList(),
                              initialIndex: index,
                            );
                          },
                          child: Image.network(
                            image.imageUrl,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),
            IconButton(
              icon: Image.asset(
                'assets/images/comment_logo.png',
                width: 30,
                height: 30,
              ),
              onPressed: () {
                final authProvider = context.read<AuthProvider>();
                if (!authProvider.isLoggedIn) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AuthDialog();
                    },
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return PostDetailPage(post: post);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
