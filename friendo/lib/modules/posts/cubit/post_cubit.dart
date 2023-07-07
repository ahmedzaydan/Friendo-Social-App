// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/models/comment_model.dart';
import 'package:friendo/models/post_model.dart';
import 'package:friendo/modules/posts/cubit/post_states.dart';
// import 'package:friendo/shared/components/custom_widgets.dart';

import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit getPostCubit(context) {
    return BlocProvider.of(context);
  }

  late FriendoCubit friendoCubit;

  /// Post images section ***************************************************************************************************

  File postImageFile = File("");

  void addPostImage({
    required BuildContext context,
    bool fromGallery = true,
  }) async {
    friendoCubit = FriendoCubit.getFriendoCubit(context);
    postImageFile = await friendoCubit.pickImage(
      fromGallery: fromGallery,
    );
    emit(AddPostImageState());
  }

  void removePostImage() {
    postImageFile = File("");
    emit(RemovePostImageState());
  }

  String getPublishDate() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
  }

  final postsCollection = FirebaseFirestore.instance.collection('posts');

  void createPost({
    required String authorId,
    required String publishDate,
    String content = '',
    required BuildContext context,
    List<String> tags = const [],
  }) async {
    try {
      String postImageURL = "";
      // If image is not empty, get its URL
      if (postImageFile.path.isNotEmpty) {
        postImageURL = await friendoCubit.uploadToStorage(
          imageFile: postImageFile,
          imagePath: 'posts',
        );
      }
      String postID = postsCollection.doc().id;
      PostModel postModel = PostModel(
        postId: postID,
        authorId: authorId,
        publishDate: publishDate,
        content: content,
        tags: tags,
        image: postImageURL,
      );
      // Upload post to Firestore
      await postsCollection.doc(postID).set(postModel.toMap());
      removePostImage(); // Reset post image
      emit(CreatePostSuccessState());
      getPostsInfo(); // 1 only get new post
    } catch (error) {
      emit(CreatePostErrorState(error.toString()));
    }
  }

  /// Get posts section ***************************************************************************************************

  Map<String, PostModel> postModels = {};
  Map<String, UserModel> userModels = {};

  void getPostsInfo() async {
    try {
      postModels = {};
      var querySnapshot = await postsCollection.get();
      for (var documentSnapshot in querySnapshot.docs) {
        PostModel postModel = PostModel.fromJson(
          json: documentSnapshot.data(),
        );
        postModels[postModel.postId!] = postModel;

        // get post author model
        userModels[postModel.authorId!] = await getUserModel(
          userId: postModel.authorId!,
        );

        // get post likers ids
        likers[postModel.postId!] = await getPostLikers(
          postId: postModel.postId!,
        );

        // get post commentModels
        commentModels[postModel.postId!] = await getPostComments(
          postId: postModel.postId!,
        );
      }
      emit(GetPostsInfoSuccessState());
    } catch (error) {
      emit(GetPostsInfoErrorState(error.toString()));
    }
  }

  Future<UserModel> getUserModel({
    required String userId,
  }) async {
    var userDocument = await usersCollection.doc(userId).get();
    return UserModel.fromJson(json: userDocument.data()!);
  }

  /// Likes section ***************************************************************************************************
  String likesCollectionName = 'likes';

  void toggleLikeStatus({
    required String postId,
    required int postModelIndex,
    required BuildContext context,
  }) async {
    // Logic to toggle the like status of the post
    // - If the post is already liked by the user, unlike it
    // - If the post is not liked by the user, like it

    var likesCollection = postsCollection.doc(postId).collection('likes');
    Query query = likesCollection.where(
      FieldPath.documentId,
      isEqualTo: currentUserId,
    );

    try {
      final querySnapshot = await query.get(); // Execute the query

      // if querySnapshot.docs.isNotEmpty = true, the post is liked by the user
      if (querySnapshot.docs.isNotEmpty) {
        await likesCollection.doc(currentUserId).delete();
        // Decrement the likesCount field in the post document
        await postsCollection.doc(postId).update(
          {'likesCount': FieldValue.increment(-1)},
        );
        likedPosts[postId] = false;
        likers[postId]!.remove(currentUserId);
      }

      // if querySnapshot.docs.isNotEmpty = false, the post is not liked by the user
      else {
        await likesCollection
            .doc(currentUserId)
            .set({}); // Add the liker document
        // Increment the likesCount field in the post document
        await postsCollection.doc(postId).update(
          {'likesCount': FieldValue.increment(1)},
        );
        likedPosts[postId] = true;
        likers[postId]!.add(currentUserId!);
      }
      updatePostModels(postId: postId);
      emit(ToggleLikeSuccessState());
    } catch (error) {
      emit(ToggleLikeErrorState(error.toString()));
    }
  }

  Map<String, bool> likedPosts = {};
  Map<String, List<String>> likers = {};

  Future<List<String>> getPostLikers({
    required String postId,
  }) async {
    List<String> likersIds = [];
    try {
      var querySnapshot = await postsCollection
          .doc(postId)
          .collection(likesCollectionName)
          .get();

      for (var likeDocument in querySnapshot.docs) {
        likersIds.add(likeDocument.id);
        // check if this post liked by current user, true if liked
        likedPosts[postId] = likeDocument.id == currentUserId ? true : false;
        await updateUserModels(userId: likeDocument.id);
      }
      emit(GetPostLikesSuccessState());
    } catch (error) {
      emit(GetPostLikesErrorState(error.toString()));
    }
    return likersIds;
  }

  /// Comments section ***************************************************************************************************

  Map<String, Map<String, CommentModel>> commentModels = {};

  Future<Map<String, CommentModel>> getPostComments({
    required String postId,
  }) async {
    Map<String, CommentModel> commentsMap = {};
    try {
      var querySnapshot = await postsCollection
          .doc(postId)
          .collection(commentsCollectionName)
          .get();

      for (var commentDocument in querySnapshot.docs) {
        CommentModel commentModel = CommentModel.fromJson(
          json: commentDocument.data(),
        );
        commentsMap[commentDocument.id] = commentModel;
        await updateUserModels(userId: commentModel.authorId);
      }
      emit(GetPostCommentsSuccessState());
    } catch (error) {
      emit(GetPostCommentsErrorState(error.toString()));
    }
    return commentsMap;
  }

  String commentsCollectionName = 'comments';
  void addComment({
    required String postId,
    required String comment,
    required String publishDate,
    required BuildContext context,
    required int postModelIndex,
  }) async {
    try {
      friendoCubit = FriendoCubit.getFriendoCubit(context);

      var commentsCollection =
          postsCollection.doc(postId).collection('comments');
      String commentId = commentsCollection.doc().id;

      CommentModel commentModel = CommentModel(
        commentId: commentId,
        postId: postId,
        comment: comment,
        publishDate: publishDate,
        authorId: currentUserId!,
      );
      await commentsCollection.doc(commentId).set(commentModel.toMap());

      // Update commentsCount field in the post document
      await postsCollection.doc(postId).update(
        {'commentsCount': FieldValue.increment(1)},
      );

      commentModels[postId]![commentId] = commentModel;

      await updateUserModels(userId: currentUserId!);

      updatePostModels(postId: postId);

      emit(CreateCommentSuccessState());
    } catch (error) {
      emit(CreateCommentErrorState(error.toString()));
    }
  }

  void updatePostModels({
    required String postId,
  }) async {
    try {
      // Get post data
      var documentSnapshot = await postsCollection.doc(postId).get();
      // Get post model
      PostModel postModel = PostModel.fromJson(json: documentSnapshot.data()!);
      postModels[postId] = postModel;
      emit(UpdatePostModelSuccessState());
    } catch (error) {
      emit(UpdatePostModelErrorState(error.toString()));
    }
  }

  Future<void> updateUserModels({
    required String userId,
  }) async {
    if (userModels[userId] != null) {
      UserModel likerModel = await getUserModel(userId: userId);
      userModels[userId] = likerModel;
    }
  }
  // bool isKeyboardVisible = false;
  // bool checkKeyboardVisibility({
  //   required BuildContext context,
  // }) {
  //   emit(CheckKeyboardVisibilityState());
  //   return View.of(context).viewInsets.bottom > 0;
  // }

  // void editPost({
  //   required PostModel postModel,
  //   String? content,
  //   String? postImage,
  //   // int? likesCount,
  //   // int? commentsCount,
  // }) {
  //   try {
  //     postsCollection.doc(postModel.postID).update({
  //       'content': content ?? postModel.content,
  //       'image': postImage ?? postModel.image,
  //     });
  //     emit(EditPostSuccessState());
  //   } catch (error) {
  //     emit(EditPostErrorState(error.toString()));
  //   }
  // }
}
