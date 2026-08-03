import 'package:flutter/material.dart';

import 'package:flutter_app/pages/post/create_post_page.dart';

class CreatePostTextfield extends StatelessWidget {
  const CreatePostTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Want to share something?",
        border: OutlineInputBorder(),
      ),
      onTap: () {
        CreatePostPage dialog = const CreatePostPage();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );
      },
    );
  }
}
