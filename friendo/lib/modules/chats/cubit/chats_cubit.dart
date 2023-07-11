import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/chats/cubit/chats_states.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/shared/components/constants.dart';

import '../../../models/message_model.dart';
import '../../../models/user_model.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit getChatsCubit(context) => BlocProvider.of(context);

  List<UserModel> users = [];

  void getUsers() async {
    try {
      users = [];
      var querySnapshot = await usersCollection.get();
      for (var element in querySnapshot.docs) {
        if (element.id != currentUserId) {
          users.add(UserModel.fromJson(json: element.data()));
        }
      }

      emit(GetChatsSuccessState());
    } catch (error) {
      emit(GetChatsErrorState(error.toString()));
    }
  }

  void sendMessage({
    required String receiverId,
    required String messageContent,
    required BuildContext context,
  }) async {
    try {
      String dateTime = PostCubit.getPostCubit(context).getPublishDate();

      var messageId = usersCollection
          .doc(currentUserId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc()
          .id;

      MessageModel messageModel = MessageModel(
        messageId: messageId,
        senderId: currentUserId!,
        receiverId: receiverId,
        dateTime: dateTime,
        message: messageContent,
      );

      // Add message to sender
      await usersCollection
          .doc(currentUserId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      // Add message to receiver
      await usersCollection
          .doc(receiverId)
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      emit(SendMessageSuccessState());
    } catch (error) {
      emit(SendMessageErrorState(error.toString()));
    }
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String receiverId,
  }) {
    final completer = Completer<List<MessageModel>>();
    usersCollection
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen(
      (event) {
        messages = [];
        for (var element in event.docs) {
          messages.add(MessageModel.fromJson(json: element.data()));
        }
        emit(GetMessagesSuccessState());
      },
    );
  }
}
