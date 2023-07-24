import 'package:flutter/material.dart';
import 'package:friendo/modules/chats/cubit/chats_cubit.dart';

import '../../models/user_model.dart';
import '../../shared/components/custom_widgets.dart';
import '../../shared/components/ui_widgets.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.receiverModel});

  final UserModel receiverModel;
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // App bar
            CustomWidgets.buildAppBar(
              context: context,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.buildIcon(
                    radius: 22,
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  UIWidgets.hSeparator(width: 20),
                  CustomWidgets.buildUserInfo(
                    context: context,
                    userModel: receiverModel,
                    imageRadius: 20.0,
                    fontSize: 20.0,
                    paddingV: 0,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ChatsCubit.getChatsCubit(context).messagesStreamBuilder(
                receiverId: receiverModel.uId!,
              ),
            ),

            // Write message
            Row(
              children: [
                Expanded(
                  child: UIWidgets.customTextFormField(
                    context: context,
                    textController: messageController,
                    hint: 'Write a message...',
                  ),
                ),

                // Send button
                IconButton(
                  onPressed: () {
                    ChatsCubit.getChatsCubit(context).sendMessage(
                      receiverId: receiverModel.uId!,
                      messageContent: messageController.text,
                      context: context,
                    );
                    messageController.clear();
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
