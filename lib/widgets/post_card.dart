import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/pages/post/post_detail_page.dart';

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
            Text(post.content, style: TextStyle(fontFamily: 'Google-Sans')),
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
                      child: Image.network(
                        image.imageUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
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
                PostDetailPage postDetailPage = PostDetailPage(post: post);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return postDetailPage;
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
