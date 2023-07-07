import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';

import 'package:friendo/shared/components/constants.dart';

import '../../shared/components/ui_widgets.dart';
import 'cubit/post_states.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        PostCubit postCubit = PostCubit.getPostCubit(context);
        return Scaffold(
          appBar: UIWidgets.customAppBar(
            context: context,
            title: "Create new post",
            actions: [
              UIWidgets.customMaterialButton(
                width: 100.0,
                isUpperCase: true,
                onPressed: () {
                  postCubit.createPost(
                    authorId: currentUserId!,
                    publishDate: postCubit.getPublishDate(),
                    content: contentController.text,
                    context: context,
                  );
                },
                text: "Post",
                context: context,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Author info
                Row(
                  children: [
                    // Author profile image
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        currentUserModel!.profileImage!,
                      ),
                    ),

                    UIWidgets.hSeparator(),

                    // Author name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              currentUserModel!.username!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                UIWidgets.vSeparator(),

                // Post content
                Expanded(
                  child: UIWidgets.customTextFormField(
                    textController: contentController,
                    keyboardType: TextInputType.text,
                    hint: "What's on your mind?",
                    context: context,
                    disableBorder: true,
                  ),
                ),

                // Post image
                if (postCubit.postImageFile.path != "")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 220.0,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(10.0),
                              // border:
                            ),
                            child: Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                    postCubit.postImageFile,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              postCubit.removePostImage();
                            },
                            icon: Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: Transform.scale(
                                scale: 1.25,
                                child: const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Photos + tags
                Row(
                  children: [
                    Expanded(
                      child: UIWidgets.customMaterialButton(
                        onPressed: () {
                          UIWidgets.showImageDialog(
                            galleryOnPressed: () {
                              postCubit.addPostImage(
                                context: context,
                              );
                              Navigator.pop(context);
                            },
                            cameraOnPressed: () {
                              postCubit.addPostImage(
                                context: context,
                                fromGallery: false,
                              );
                              Navigator.pop(context);
                            },
                            context: context,
                          );
                        },
                        text: "Add photos",
                        context: context,
                        isUpperCase: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
