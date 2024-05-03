import 'package:flutter/material.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/shared/components/custom_widgets.dart';
import 'package:friendo/shared/components/ui_widgets.dart';
import 'package:friendo/shared/styles/color.dart';

import '../../../models/comment_model.dart';

class UpdateCommentScreen extends StatelessWidget {
  final CommentModel oldComment;

  UpdateCommentScreen({
    super.key,
    required this.oldComment,
  });
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    textController.text = oldComment.comment;
    return Scaffold(
      body: Column(
        children: [
          // AppBar
          CustomWidgets.buildAppBar(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.buildIcon(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Comment text field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: UIWidgets.customTextFormField(
              context: context,
              textController: textController,
            ),
          ),

          // Update comment button
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color2,
            ),
            child: TextButton(
              onPressed: () {
                // Update comment
                PostCubit.getPostCubit(context).updateComment(
                  postId: oldComment.postId,
                  commentId: oldComment.commentId,
                  comment: textController.text,
                );
              },
              child: Text(
                'Update',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
