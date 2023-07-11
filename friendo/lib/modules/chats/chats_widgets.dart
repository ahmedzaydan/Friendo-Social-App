import 'package:flutter/material.dart';
import 'package:friendo/shared/components/constants.dart';

import '../../models/message_model.dart';

class ChatWidgets {
  static Widget buildMessage({
    required MessageModel messageModel,
    required BuildContext context,
  }) {
    bool isMe = messageModel.senderId == currentUserId!;
    double radius = 8;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: isMe ? Radius.circular(radius) : Radius.zero,
            bottomEnd: isMe ? Radius.zero : Radius.circular(radius),
            topStart: Radius.circular(radius),
            topEnd: Radius.circular(radius),
          ),
        ),
        child: Text(
          messageModel.message,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
