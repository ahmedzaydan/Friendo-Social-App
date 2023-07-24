// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/models/comment_model.dart';
import 'package:friendo/models/post_model.dart';
import 'package:friendo/modules/posts/cubit/post_states.dart';
import 'package:intl/intl.dart';

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
      getPosts(); // 1 only get new post
    } catch (error) {
      emit(CreatePostErrorState(error.toString()));
    }
  }

  void updatePost({
    required PostModel postModel,
    required String content,
    String? image,
    List<String>? tags,
  }) {
    postsCollection.doc(postModel.postId).update(
      {
        'content': content,
        'image': image ?? postModel.image,
        'publishDate': getPublishDate(),
        'tags': tags ?? postModel.tags,
      },
    ).catchError(
      (error) {
        emit(UpdatePostErrorState(error.toString()));
      },
    );
  }

  void deletePost({
    required String postId,
  }) {
    postsCollection.doc(postId).delete().catchError(
      (error) {
        emit(DeletePostErrorState(error.toString()));
      },
    );
  }

  Stream<List<PostModel>> getPosts() {
    var streamController = StreamController<List<PostModel>>();
    postsCollection.snapshots().listen((event) {
      List<PostModel> postModels = [];
      for (var element in event.docs) {
        PostModel postModel = PostModel.fromJson(
          json: element.data(),
        );
        postModels.add(postModel);
      }
      streamController.add(postModels);
    }, onError: (error) {
      streamController.addError(error.toString());
    });
    return streamController.stream;
  }

  Future<PostModel> getPostModel({
    required String postId,
  }) async {
    var document = await postsCollection.doc(postId).get();
    return PostModel.fromJson(json: document.data()!);
  }

  String getPublishDate() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";
  }

  String parsePublishData({
    required String publishDate,
  }) {
    DateTime now = DateTime.now();
    DateTime publishDateTime = DateFormat('MM/dd/yyyy H:mm').parse(publishDate);
    Duration difference = now.difference(publishDateTime);

    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      return "$years y";
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return "$months mo";
    } else if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks w";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} d";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} h";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} m";
    } else {
      return "Just now";
    }
  }

  /// Likes section ***************************************************************************************************
  void toggleLike({
    required String postId,
    String? commentId,
    required BuildContext context,
  }) {
    var likesCollection = commentId == null
        ? postsCollection.doc(postId).collection('likes')
        : postsCollection
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('likes');
    Query query = likesCollection.where(
      FieldPath.documentId,
      isEqualTo: currentUId,
    );
    var document = commentId == null
        ? postsCollection.doc(postId)
        : postsCollection.doc(postId).collection('comments').doc(commentId);
    query.get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          likesCollection.doc(currentUId).delete();
          document.update(
            {'likesCount': FieldValue.increment(-1)},
          );
        } else {
          likesCollection.doc(currentUId).set({});
          document.update(
            {'likesCount': FieldValue.increment(1)},
          );
        }
      },
    ).catchError(
      (error) {
        emit(ToggleLikeErrorState(error.toString()));
      },
    );
  }

  Stream<bool> isLiked({
    required String postId,
    String? commentId,
  }) {
    var streamController = StreamController<bool>();
    var path = commentId == null 
    ? postsCollection
        .doc(postId)
        .collection('likes') 
    : postsCollection
            .doc(postId)
            .collection('comments').doc(commentId).collection('likes');
        path.doc(currentUId)
        .snapshots()
        .listen(
      (event) {
        streamController.add(event.exists);
      },
      onError: (error) {
        streamController.addError(error.toString());
      },
    );
    return streamController.stream;
  }

  Stream<List<String>> getPostLikers({
    required String postId,
  }) {
    var streamController = StreamController<List<String>>();
    postsCollection.doc(postId).collection('likes').snapshots().listen(
      (event) {
        List<String> likers = [];
        for (var document in event.docs) {
          likers.add(document.id);
          // check if this post is liked by the current user
        }
        streamController.add(likers);
      },
      onError: (error) {
        streamController.addError(error.toString());
      },
    );

    return streamController.stream;
  }

  /// Comments section ***************************************************************************************************
  void addComment({
    required String postId,
    required String comment,
    required String publishDate,
  }) async {
    try {
      var commentsCollection =
          postsCollection.doc(postId).collection('comments');
      String commentId = commentsCollection.doc().id;

      CommentModel commentModel = CommentModel(
        commentId: commentId,
        postId: postId,
        comment: comment,
        publishDate: publishDate,
        authorId: currentUId!,
      );
      await commentsCollection.doc(commentId).set(commentModel.toMap());
      // Update commentsCount field in the post document
      await postsCollection.doc(postId).update(
        {'commentsCount': FieldValue.increment(1)},
      );
    } catch (error) {
      emit(CreateCommentErrorState(error.toString()));
    }
  }

  Stream<Map<String, CommentModel>> getPostComments({
    required String postId,
  }) {
    var streamController = StreamController<Map<String, CommentModel>>();
    postsCollection.doc(postId).collection('comments').snapshots().listen(
      (event) {
        Map<String, CommentModel> comments = {};
        for (var document in event.docs) {
          comments[document.id] = CommentModel.fromJson(
            json: document.data(),
          );
        }
        streamController.add(comments);
      },
      onError: (error) {
        streamController.addError(error.toString());
      },
    );
    return streamController.stream;
  }

  void updateComment({
    required String postId,
    required String commentId,
    required String comment,
  }) {
    postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
          'comment': comment,
          'publishDate': getPublishDate(),
        })
        .then(
          (value) {},
        )
        .catchError(
          (error) {
            emit(UpdateCommentErrorState(error.toString()));
          },
        );
  }

  void deleteComment({
    required String postId,
    required String commentId,
  }) {
    postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then(
          (value) {},
        )
        .catchError(
      (error) {
        emit(DeleteCommentErrorState(error.toString()));
      },
    );
  }

  /// Save post section ***************************************************************************************************
  void toggleSave({
    required String postId,
    required int postModelIndex,
    required BuildContext context,
  }) async {
    // Logic to toggle the like status of the post
    // - If the post is already liked by the user, unlike it
    // - If the post is not liked by the user, like it

    // var likesCollection = postsCollection.doc(postId).collection('likes');
    // Query query = likesCollection.where(
    //   FieldPath.documentId,
    //   isEqualTo: currentUId,
    // );

    // try {
    //   final querySnapshot = await query.get(); // Execute the query

    //   // if querySnapshot.docs.isNotEmpty = true, the post is liked by the user
    //   if (querySnapshot.docs.isNotEmpty) {
    //     await likesCollection.doc(currentUId).delete();
    //     // Decrement the likesCount field in the post document
    //     await postsCollection.doc(postId).update(
    //       {'likesCount': FieldValue.increment(-1)},
    //     );
    //     likedPosts[postId] = false;
    //     likers[postId]!.remove(currentUId);
    //   }

    //   // if querySnapshot.docs.isNotEmpty = false, the post is not liked by the user
    //   else {
    //     await likesCollection.doc(currentUId).set({}); // Add the liker document
    //     // Increment the likesCount field in the post document
    //     await postsCollection.doc(postId).update(
    //       {'likesCount': FieldValue.increment(1)},
    //     );
    //     likedPosts[postId] = true;
    //     likers[postId]!.add(currentUId!);
    //   }
    //   updatePostModels(postId: postId);
    //   emit(ToggleLikeSuccessState());
    // } catch (error) {
    //   emit(ToggleLikeErrorState(error.toString()));
    // }
  }
}
