import 'package:flutter/material.dart';

import '../../../models/post_model.dart';
import '../../../shared/components/custom_widgets.dart';
import '../../../shared/components/ui_widgets.dart';
import '../../../shared/styles/color.dart';
import '../cubit/post_cubit.dart';

class UpdatePostScreen extends StatelessWidget {
  final PostModel oldPostModel;
  final textController = TextEditingController();
  UpdatePostScreen({
    super.key,
    required this.oldPostModel,
  });
  @override
  Widget build(BuildContext context) {
    textController.text = oldPostModel.content;
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
                  const Spacer(),
                  // Update post button
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: color2,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Update post
                        PostCubit.getPostCubit(context).updatePost(
                          postModel: oldPostModel,
                          content: textController.text,
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
            ),
          ),

          // Post text field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: UIWidgets.customTextFormField(
              context: context,
              textController: textController,
            ),
          ),

          const Spacer(),

          //1 Post image
          // if (oldPostModel.image != '')
          //   Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: SizedBox(
          //       height: MediaQuery.sizeOf(context).height * 0.25,
          //       child: Stack(
          //         alignment: Alignment.topRight,
          //         children: [
          //           Container(
          //             padding: const EdgeInsets.all(5.0),
          //             decoration: BoxDecoration(
          //               color: Colors.grey[800],
          //               borderRadius: BorderRadius.circular(10.0),
          //               // border:
          //             ),
          //             // image
          //             child: Container(
          //               height: MediaQuery.sizeOf(context).height * 0.25,
          //               decoration: BoxDecoration(
          //                 image: DecorationImage(
          //                   image: NetworkImage(
          //                     oldPostModel.image,
          //                   ),
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           IconButton(
          //             onPressed: () {
          //               // postCubit.removePostImage();
          //             },
          //             icon: Positioned(
          //               right: 0.0,
          //               top: 0.0,
          //               child: Transform.scale(
          //                 scale: 1.25,
          //                 child: const CircleAvatar(
          //                   backgroundColor: Colors.grey,
          //                   child: Icon(
          //                     Icons.close,
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
