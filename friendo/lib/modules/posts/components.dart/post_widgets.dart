import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/models/comment_model.dart';
import 'package:friendo/models/post_model.dart';
import 'package:friendo/modules/posts/posts_screens/update_comment_screen.dart';
import 'package:friendo/modules/posts/posts_screens/update_post_screen.dart';
import 'package:friendo/shared/components/ui_widgets.dart';
import 'package:friendo/shared/components/constants.dart';

import '../../../models/user_model.dart';
import '../../../shared/components/custom_widgets.dart';
import '../../../shared/styles/color.dart';
import '../cubit/post_cubit.dart';

class PostWidgets {
  static Widget buildPostCard({
    required BuildContext context,
    required PostModel postModel,
    required UserModel authorModel,
    double margin = 10.0,
    Color? backgroundColor,
  }) {
    var txtTheme = Theme.of(context).textTheme;
    TextStyle txtStyle = txtTheme.bodyLarge!;

    List<Widget> tags = [];
    for (var tag in postModel.tags) {
      tags.add(Text(tag));
    }

    final postCubit = PostCubit.getPostCubit(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? color1,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomWidgets.buildUserInfo(
                  context: context,
                  userModel: authorModel,
                  publishDate: postCubit.parsePublishData(
                    publishDate: postModel.publishDate.toString(),
                  ),
                  isCurrentUser: authorModel.uId == currentUId,
                  paddingH: 0,
                ),
              ),
              if (authorModel.uId! == currentUId)
                PopupMenuButton<String>(
                  constraints: const BoxConstraints(
                    minWidth: 10.0,
                    maxWidth: 75,
                  ),
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
                        UIWidgets.navigateTo(
                          context: context,
                          destination: UpdatePostScreen(
                            oldPostModel: postModel,
                          ),
                        );
                        break;
                      case 'Delete':
                        PostCubit.getPostCubit(context).deletePost(
                          postId: postModel.postId!,
                        );
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
              if (tags.isNotEmpty)
                Wrap(
                  children: postModel.tags.map(
                    (tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: txtTheme.bodyLarge,
                        ),
                      );
                    },
                  ).toList(),
                ),
            ],
          ),

          // Post image
          if (postModel.image != "")
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image(
                  height: 250,
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
              // Like button
              StreamBuilder<bool>(
                stream: postCubit.isLiked(
                  postId: postModel.postId!,
                ),
                builder: (context, likeSnapshot) {
                  if (likeSnapshot.connectionState == ConnectionState.waiting) {
                    return CustomWidgets.buildStreamBuilderWaiting();
                  }
                  if (likeSnapshot.hasError) {
                    return CustomWidgets.buildStreamBuilderError(
                        likeSnapshot.error.toString());
                  }
                  bool isLiked = likeSnapshot.data!;
                  return IconButton(
                    onPressed: () {
                      postCubit.toggleLike(
                        postId: postModel.postId!,
                        context: context,
                      );
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      size: iconSize * 1.5,
                      color: color5,
                    ),
                  );
                },
              ),

              // Likes count
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(0, 0),
                  ),
                ),
                child: Text(
                  '${postModel.likesCount}',
                ),
                onPressed: () {
                  UIWidgets.customShowModalBottomSheet(
                    context: context,
                    postId: postModel.postId!,
                    authorModel: authorModel,
                    isLikeAction: true,
                  );
                },
              ),

              // Comment button
              IconButton(
                onPressed: () {
                  // buildPostComme(
                  //   context: context,
                  //   postModel: postModel,
                  //   authorModel: authorModel,
                  // );
                },
                icon: Icon(
                  size: iconSize * 1.5,
                  Icons.chat_bubble_outline,
                  color: color5,
                ),
              ),

              // Comments count
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(0, 0),
                  ),
                ),
                child: Text(
                  '${postModel.commentsCount}',
                ),
                onPressed: () {
                  TextEditingController commentController =
                      TextEditingController();
                  UIWidgets.customShowModalBottomSheet(
                    isLikeAction: false,
                    postId: postModel.postId!,
                    authorModel: authorModel,
                    context: context,
                    widget: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                bottom: 10,
                              ),
                              child: UIWidgets.customTextFormField(
                                textController: commentController,
                                hint: "Write a comment....",
                                context: context,
                                disableBorder: true,
                              ),
                            ),
                          ),

                          // Send button
                          IconButton(
                            onPressed: () {
                              if (commentController.text.isNotEmpty) {
                                PostCubit.getPostCubit(context).addComment(
                                  comment: commentController.text,
                                  publishDate: PostCubit.getPostCubit(context)
                                      .getPublishDate(),
                                  postId: postModel.postId!,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  commentController.clear();
                },
              ),

              const Spacer(),
              // Save button
              IconButton(
                onPressed: () {
                  if (kDebugMode) print("Save");
                },
                icon: Icon(
                  size: iconSize * 1.5,
                  // isSaved ? Icons.bookmark :
                  Icons.bookmark_outline,
                  color: color5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildPosts({
    required BuildContext context,
    Widget? appBar,
    Widget? widget,
    Color? backgroundColor,
  }) {
    return StreamBuilder<Map<String, UserModel>>(
      stream: FriendoCubit.getFriendoCubit(context).getUserModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomWidgets.buildStreamBuilderWaiting();
        }
        if (snapshot.hasError) {
          return CustomWidgets.buildStreamBuilderError(
              snapshot.error.toString());
        }
        Map<String, UserModel> users = snapshot.data!;
        if (users.isEmpty) {
          return CustomWidgets.buildStreamBuilderNoData('No users yet');
        }
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (appBar != null) appBar,
                StreamBuilder<List<PostModel>>(
                  stream: PostCubit.getPostCubit(context).getPosts(),
                  builder: (context, postsSnapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomWidgets.buildStreamBuilderWaiting();
                    }
                    if (snapshot.hasError) {
                      return CustomWidgets.buildStreamBuilderError(
                        snapshot.error.toString(),
                      );
                    }
                    List<PostModel> posts = postsSnapshot.data ?? [];
                    if (posts.isEmpty) {
                      return CustomWidgets.buildStreamBuilderNoData(
                        'No posts yet',
                      );
                    }
                    return Column(
                      children: [
                        if (widget != null) widget,
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return PostWidgets.buildPostCard(
                              context: context,
                              postModel: posts[index],
                              authorModel: users[posts[index].authorId]!,
                              backgroundColor: backgroundColor,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              UIWidgets.vSeparator(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildPostLikers({
    required String postId,
    required bool isCurrentUser,
    required BuildContext context,
  }) {
    return StreamBuilder<Map<String, UserModel>>(
        stream: FriendoCubit.getFriendoCubit(context).getUserModels(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return CustomWidgets.buildStreamBuilderWaiting();
          }
          if (usersSnapshot.hasError) {
            return CustomWidgets.buildStreamBuilderError(
                usersSnapshot.error.toString());
          }
          Map<String, UserModel> users = usersSnapshot.data ?? {};
          if (users.isEmpty) {
            return CustomWidgets.buildStreamBuilderNoData('No users yet');
          }
          return StreamBuilder<List<String>>(
            stream:
                PostCubit.getPostCubit(context).getPostLikers(postId: postId),
            builder: (context, likersSnapshot) {
              if (likersSnapshot.connectionState == ConnectionState.waiting) {
                return CustomWidgets.buildStreamBuilderWaiting();
              }

              if (likersSnapshot.hasError) {
                return CustomWidgets.buildStreamBuilderError(
                    likersSnapshot.error.toString());
              }

              List<String> likers = likersSnapshot.data ?? [];
              if (likers.isEmpty) {
                return CustomWidgets.buildStreamBuilderNoData('No likers yet');
              }
              return ListView.builder(
                itemCount: likers.length,
                itemBuilder: (context, index) {
                  return CustomWidgets.buildUserInfo(
                    context: context,
                    userModel: users[likers[index]]!,
                    isCurrentUser: isCurrentUser,
                    paddingV: 5.0,
                  );
                },
              );
            },
          );
        });
  }

  /// comments widgets
  static Widget buildComment({
    required CommentModel commentModel,
    required UserModel authorModel,
    required BuildContext context,
    bool isCurrentUser = false,
  }) {
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
                color: Colors.white,
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomWidgets.buildUserInfo(
                          context: context,
                          userModel: authorModel,
                          paddingH: 0,
                          imageRadius: 20,
                        ),
                        if (authorModel.uId! == currentUId)
                          PopupMenuButton<String>(
                            constraints: const BoxConstraints(
                              minWidth: 10.0,
                              maxWidth: 75,
                            ),
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
                                  UIWidgets.navigateTo(
                                    context: context,
                                    destination: UpdateCommentScreen(
                                      oldComment: commentModel,
                                    ),
                                  );
                                  break;
                                case 'Delete':
                                  PostCubit.getPostCubit(context).deleteComment(
                                    commentId: commentModel.commentId,
                                    postId: commentModel.postId,
                                  );
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

            // Comment info
            StreamBuilder<bool>(
                stream: PostCubit.getPostCubit(context).isLiked(
                  postId: commentModel.postId,
                  commentId: commentModel.commentId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomWidgets.buildStreamBuilderWaiting();
                  }
                  if (snapshot.hasError) {
                    return CustomWidgets.buildStreamBuilderError(
                        snapshot.error.toString());
                  }
                  bool isLiked = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          PostCubit.getPostCubit(context).parsePublishData(
                            publishDate: commentModel.publishDate,
                          ),
                        ),

                        // Like button
                        TextButton(
                          onPressed: () {
                            PostCubit.getPostCubit(context).toggleLike(
                              postId: commentModel.postId,
                              context: context,
                              commentId: commentModel.commentId,
                            );
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.only(left: 5.0),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(0, 0)),
                          ),
                          child: Text(
                            isLiked ? 'Liked' : 'Like',
                            style: TextStyle(
                              color: isLiked ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),

                        // Likes count
                        Text(
                          "${commentModel.likesCount}",
                        ),

                        // 2 Reply button
                        // TextButton(
                        //   onPressed: () {},
                        //   style: ButtonStyle(
                        //     padding:
                        //         MaterialStateProperty.all<EdgeInsetsGeometry>(
                        //       const EdgeInsets.only(left: 5.0),
                        //     ),
                        //     minimumSize:
                        //         MaterialStateProperty.all<Size>(const Size(0, 0)),
                        //   ),
                        //   child: const Text(
                        //     'Reply',
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  static Widget buildPostComments({
    required String postId,
    required bool isCurrentUser,
    required BuildContext context,
  }) {
    return StreamBuilder<Map<String, UserModel>>(
        stream: FriendoCubit.getFriendoCubit(context).getUserModels(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return CustomWidgets.buildStreamBuilderWaiting();
          }
          if (usersSnapshot.hasError) {
            return CustomWidgets.buildStreamBuilderError(
                usersSnapshot.error.toString());
          }
          Map<String, UserModel> users = usersSnapshot.data ?? {};
          if (users.isEmpty) {
            return CustomWidgets.buildStreamBuilderNoData('No users yet');
          }
          return StreamBuilder<Map<String, CommentModel>>(
            stream:
                PostCubit.getPostCubit(context).getPostComments(postId: postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomWidgets.buildStreamBuilderWaiting();
              }

              if (snapshot.hasError) {
                return CustomWidgets.buildStreamBuilderError(
                    snapshot.error.toString());
              }

              List<CommentModel> comments = snapshot.data!.values.toList();
              if (comments.isEmpty) {
                return CustomWidgets.buildStreamBuilderNoData(
                  'No comments yet',
                );
              }

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: PostWidgets.buildComment(
                      context: context,
                      commentModel: comments[index],
                      authorModel: users[comments[index].authorId]!,
                      isCurrentUser: isCurrentUser,
                    ),
                  );
                },
              );
              // return const SizedBox();
            },
          );
        });
  }
}

/// OLd comment info style
// Container(
//   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Row(
//         children: [
//           Text(
//             PostCubit.getPostCubit(context).parsePublishData(
//               publishDate: commentModel.publishDate,
//             ),
//           ),

//           // Like button
//           TextButton(
//             onPressed: () {},
//             style: ButtonStyle(
//               padding:
//                   MaterialStateProperty.all<EdgeInsetsGeometry>(
//                 const EdgeInsets.only(left: 5.0),
//               ),
//               minimumSize:
//                   MaterialStateProperty.all<Size>(const Size(0, 0)),
//             ),
//             child: const Text(
//               'Like',
//               style: TextStyle(
//                 color:
//                     // isLiked ? Colors.red :
//                     Colors.blue,
//               ),
//             ),
//           ),

//           // Likes count
//           Text(
//             "${commentModel.likesCount}",
//           ),

//           // 2 Reply button
//           // TextButton(
//           //   onPressed: () {},
//           //   style: ButtonStyle(
//           //     padding:
//           //         MaterialStateProperty.all<EdgeInsetsGeometry>(
//           //       const EdgeInsets.only(left: 5.0),
//           //     ),
//           //     minimumSize:
//           //         MaterialStateProperty.all<Size>(const Size(0, 0)),
//           //   ),
//           //   child: const Text(
//           //     'Reply',
//           //     style: TextStyle(
//           //       color: Colors.black,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),

//       // Like button
//     ],
//   ),
// ),