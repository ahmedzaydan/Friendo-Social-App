import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/chats/cubit/chats_states.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/components/custom_widgets.dart';
import 'package:http/http.dart' as http;

import '../../../models/message_model.dart';
import '../../../shared/components/ui_widgets.dart';
import '../chats_widgets.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit getChatsCubit(context) => BlocProvider.of(context);

  Future<void> sendMessage({
    required String receiverId,
    required String messageContent,
    required BuildContext context,
  }) async {
    try {
      String dateTime = PostCubit.getPostCubit(context).getPublishDate();

      var messageId = usersCollection
          .doc(currentUId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc()
          .id;

      MessageModel messageModel = MessageModel(
        messageId: messageId,
        senderId: currentUId!,
        receiverId: receiverId,
        dateTime: dateTime,
        message: messageContent,
      );

      // Add message to sender
      await usersCollection
          .doc(currentUId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      // Add message to receiver
      await usersCollection
          .doc(receiverId)
          .collection('chats')
          .doc(currentUId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      // Send notification
      // sendNotification(
      //   receiverToken: SMJ6Token,
      //   notificationTitle: 'New message',
      //   notificationBody: messageContent,
      // );

      sendFCMNotification(
        targetToken: userModels[receiverId]!.deviceToken!,
      );
      emit(SendMessageSuccessState());
    } catch (error) {
      emit(SendMessageErrorState(error.toString()));
    }
  }

  Stream<List<MessageModel>> getMessages({
    required String receiverId,
  }) {
    var streamController = StreamController<List<MessageModel>>();
    usersCollection
        .doc(currentUId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen(
      (event) {
        List<MessageModel> messages = [];
        for (var element in event.docs) {
          messages.add(
            MessageModel.fromJson(
              json: element.data(),
            ),
          );
        }
        streamController.add(messages);
      },
      onError: (error) {
        streamController.addError(error);
      },
    );
    return streamController.stream;
  }

  Widget messagesStreamBuilder({
    required String receiverId,
  }) {
    return StreamBuilder<List<MessageModel>>(
      stream: getMessages(receiverId: receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return CustomWidgets.buildStreamBuilderWaiting();
        }

        if (snapshot.hasError) {
         return CustomWidgets.buildStreamBuilderError(snapshot.error.toString());
        }

        if (snapshot.data == null) {
         return CustomWidgets.buildStreamBuilderNoData('No messages yet');
        }
        List<MessageModel> messages = snapshot.data!;
        return ListView.separated(
          itemBuilder: (context, index) {
            return ChatWidgets.buildMessage(
              messageModel: messages[index],
              context: context,
            );
          },
          separatorBuilder: (context, index) => UIWidgets.vSeparator(),
          itemCount: messages.length,
        );
      },
    );
  }

  Future<void> sendFCMNotification({
    required String targetToken,
    // required String notificationTitle,
    // required String notificationBody,
  }) async {
    // Request permission to receive notifications
    // NotificationSettings settings =
    //     await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // Construct the notification message
    final message = {
      'notification': {
        'title': 'Hello',
        'body': 'This is a test notification',
      },
      'to': targetToken,
    };

    // Send the FCM notification
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAhU0Uc4s:APA91bH47FUsH68eCj98ljyL7gOTm11MMCReQFThjC2LIuzBuVc8q4RQbFUaDkay1npxY1yVthLlFnxLu7WU2uRuQ5jz5no5-I6-b19WOiFnEbjZ77QFDUqpmN_ez825Ljz8cM1_Buaw',
      },
      body: jsonEncode(message),
    );
  }
}

  // Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  //   UIWidgets
  // }

  // void sendNotification({
  //   required String receiverToken,
  //   required String notificationTitle,
  //   required String notificationBody,
  // }) {
  //   FCMHandler.sendData(
  //     data: {
  //       'to': receiverToken,
  //       'notification': {
  //         'title': notificationTitle,
  //         'body': notificationBody,
  //         'sound': 'default',
  //       },
  //       'android': {
  //         'priority': 'HIGH',
  //         'notification': {
  //           'notification_priority': 'PRIORITY_MAX',
  //           'sound': 'default',
  //           'default_sound': true,
  //           'default_vibrate_timings': true,
  //           'default_light_settings': true,
  //         },
  //       },
  //       'data': {
  //         'type': 'order',
  //         'id': '123',
  //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //       },
  //     },
  //   );
  // }
