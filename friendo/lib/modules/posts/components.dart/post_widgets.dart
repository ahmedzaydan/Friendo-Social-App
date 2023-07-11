import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendo/models/comment_model.dart';
import 'package:friendo/models/post_model.dart';
import 'package:friendo/shared/components/ui_widgets.dart';
import 'package:friendo/shared/components/constants.dart';

import '../../../models/user_model.dart';
import '../../../shared/components/custom_widgets.dart';
import '../../edit_profile_screen.dart';
import '../cubit/post_cubit.dart';
import '../posts_screens/new_post_screen.dart';

class PostWidgets {
  static Widget buildPostCard({
    required BuildContext context,
    required PostModel postModel,
    required int postModelIndex,
  }) {
    var txtTheme = Theme.of(context).textTheme;
    TextStyle txtStyle = txtTheme.bodyLarge!;

    List<Widget> tags = [];
    for (var tag in postModel.tags) {
      tags.add(Text(tag));
    }

    final postCubit = PostCubit.getPostCubit(context);
    UserModel authorModel = postCubit.userModels[postModel.authorId]!;
    bool isLiked = postCubit.likedPosts[postModel.postId] ?? false;

    return Card(
      color: Colors.deepPurple[40],
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author's name, profile image, and post publish date
            Row(
              children: [
                // Author profile image
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                    authorModel.profileImage!,
                  ),
                ),

                UIWidgets.hSeparator(),

                // Name and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name
                    Row(
                      children: [
                        Text(
                          authorModel.username!,
                          style: txtStyle,
                        ),
                      ],
                    ),

                    // Publish date
                    Text(
                      postModel.publishDate!,
                    ),
                  ],
                ),
              ],
            ),

            UIWidgets.vSeparator(),

            // Post content and tags
            Column(
              children: [
                // Post content
                Text(
                  postModel.content,
                  style: txtStyle,
                ),

                UIWidgets.vSeparator(height: 5.0),

                //1 Post tags
                // if (tags.isNotEmpty)
                //   Wrap(
                //     children: postModel.tags.map((tag) {
                //       return Chip(
                //         label: Text(
                //           tag,
                //           style: txtTheme.bodyLarge,
                //         ),
                //       );
                //     }).toList()
                //   ),
              ],
            ),

            // Post image
            if (postModel.image != "")
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image(
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      postModel.image,
                    ),
                  ),
                ),
              ),

            UIWidgets.vSeparator(),

            // Post likes, comments
            Row(
              children: [
                // Likes
                Expanded(
                  child: InkWell(
                    onTap: () {
                      UIWidgets.customShowModalBottomSheet(
                        context: context,
                        postId: postModel.postId!,
                        isLikeAction: true,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "${postModel.likesCount} Likes",
                          style: txtTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Comments
                Expanded(
                  child: InkWell(
                    onTap: () {
                      TextEditingController commentController =
                          TextEditingController();

                      UIWidgets.customShowModalBottomSheet(
                        isLikeAction: false,
                        postId: postModel.postId!,
                        context: context,
                        widget: Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: UIWidgets.customTextFormField(
                                    textController: commentController,
                                    hint: "Write a comment....",
                                    context: context,
                                    // autofocus: false,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    postCubit.addComment(
                                      postId: postModel.postId!,
                                      comment: commentController.text,
                                      publishDate: postCubit.getPublishDate(),
                                      context: context,
                                      postModelIndex: postModelIndex,
                                    );
                                    commentController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${postModel.commentsCount} Comments",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            UIWidgets.vSeparator(),

            // Post actions
            Row(
              children: [
                // Like
                Expanded(
                  child: InkWell(
                    onTap: () {
                      postCubit.toggleLikeStatus(
                        postId: postModel.postId!,
                        postModelIndex: postModelIndex,
                        context: context,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLikeButton(isLiked: isLiked),
                        UIWidgets.hSeparator(width: 5.0),
                        Text(
                          isLiked ? "Liked" : "Like",
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ],
                    ),
                  ),
                ),

                // Comment
                Expanded(
                  child: InkWell(
                    onTap: () {
                      TextEditingController commentController =
                          TextEditingController();

                      UIWidgets.customShowModalBottomSheet(
                        isLikeAction: false,
                        postId: postModel.postId!,
                        context: context,
                        widget: Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: UIWidgets.customTextFormField(
                                    textController: commentController,
                                    hint: "Write a comment....",
                                    context: context,
                                    // autofocus: false,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    postCubit.addComment(
                                      postId: postModel.postId!,
                                      comment: commentController.text,
                                      publishDate: postCubit.getPublishDate(),
                                      context: context,
                                      postModelIndex: postModelIndex,
                                    );
                                    commentController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          size: iconSize * 1.5,
                          Icons.comment_rounded,
                          color: Colors.black45,
                        ),
                        UIWidgets.hSeparator(
                          width: 5.0,
                        ),
                        Text(
                          "Comment",
                          style: txtTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildProfileScreen({
    required BuildContext context,
    required UserModel userModel,
    bool isCurrentUser = false,
    bool showAppBar = true,
  }) {
    TextTheme? txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: showAppBar
          ? UIWidgets.customAppBar(
              context: context,
              title: userModel.username!,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Cover image + profile image
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  // Cover image
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: double.infinity,
                        height: 190,
                        child: CachedNetworkImage(
                          imageUrl: userModel.coverImage!,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userModel.coverImage!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )),
                  ),

                  // Profile image
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CachedNetworkImage(
                        imageUrl: userModel.profileImage!,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              userModel.profileImage!,
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Name
            Text(
              userModel.username!,
              style: txtTheme.bodyLarge,
            ),

            // Bio
            Text(
              userModel.bio!,
              style: txtTheme.bodyMedium,
            ),

            // Statistics
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  // Posts
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '100',
                          style: txtTheme.labelMedium,
                        ),
                        const Text(
                          'Posts',
                        ),
                      ],
                    ),
                  ),

                  // Photos
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '200',
                          style: txtTheme.labelMedium,
                        ),
                        const Text(
                          'Photos',
                        ),
                      ],
                    ),
                  ),

                  // Followers
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '1K',
                          style: txtTheme.labelMedium,
                        ),
                        const Text(
                          'Followers',
                        ),
                      ],
                    ),
                  ),

                  // Followings
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '100K',
                          style: txtTheme.labelMedium,
                        ),
                        const Text(
                          'Followings',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            if (isCurrentUser)
              Row(
                children: [
                  Expanded(
                    child: UIWidgets.customMaterialButton(
                      onPressed: () {
                        UIWidgets.navigateTo(
                          context: context,
                          destination: NewPostScreen(),
                        );
                      },
                      text: "Add post",
                      context: context,
                      isUpperCase: true,
                    ),
                  ),
                  UIWidgets.hSeparator(),
                  Expanded(
                    child: UIWidgets.customMaterialButton(
                      onPressed: () {
                        UIWidgets.navigateTo(
                          context: context,
                          destination: EditProfileScreen(),
                        );
                      },
                      text: "Edit profile",
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
  }

 

  static Widget buildLikeButton({
    required bool isLiked,
  }) {
    return Icon(
      isLiked ? Icons.favorite : Icons.favorite_outline,
      color: Colors.red,
      size: iconSize * 1.5,
    );
  }

  static Widget buildComment({
    required CommentModel commentModel,
    required UserModel authorModel,
    required BuildContext context,
    bool isCurrentUser = false,
  }) {
    bool isLiked = true;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment author info and content
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                border: Border.all(
                  color: Colors.grey,
                ),
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Author info
                        CustomWidgets.buildUserInfo(
                          context: context,
                          userModel: authorModel,
                          isCurrentUser: isCurrentUser,
                        ),

                        if (authorModel.uid! == currentUserId)
                          PopupMenuButton<String>(
                            itemBuilder: (context) {
                              return <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              // Handle the selected option
                              switch (value) {
                                case 'Edit':
                                  if (kDebugMode) print('Edit');
                                  break;
                                case 'Delete':
                                  if (kDebugMode) print('Delete');
                                  break;
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.grey[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                  UIWidgets.vSeparator(height: 5.0),

                  // Comment content
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      commentModel.comment,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    ),
                  ),
                ],
              ),
            ),

            UIWidgets.vSeparator(height: 5.0),

            // Comment publish date + like
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        PostCubit.getPostCubit(context).parsePublishData(
                            publishDate: commentModel.publishDate),
                      ),

                      // Like button
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.only(left: 5.0),
                          ),
                          minimumSize:
                              MaterialStateProperty.all<Size>(const Size(0, 0)),
                        ),
                        child: Text(
                          isLiked ? 'Liked' : 'Like',
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.blue,
                          ),
                        ),
                      ),

                      // Reply button
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.only(left: 5.0),
                          ),
                          minimumSize:
                              MaterialStateProperty.all<Size>(const Size(0, 0)),
                        ),
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Likes count
                  Text(
                    "${commentModel.likesCount} Likes",
                  ),
                  // Like button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
