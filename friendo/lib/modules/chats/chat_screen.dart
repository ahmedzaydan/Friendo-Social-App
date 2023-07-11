import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/chats/chats_widgets.dart';
import 'package:friendo/shared/components/custom_widgets.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../models/user_model.dart';
import 'cubit/chats_cubit.dart';
import 'cubit/chats_states.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.receiverModel});

  final UserModel receiverModel;
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ChatsCubit.getChatsCubit(context)
            .getMessages(receiverId: receiverModel.uid!);
        return BlocConsumer<ChatsCubit, ChatsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final ChatsCubit chatsCubit = ChatsCubit.getChatsCubit(context);
            return Scaffold(
              appBar: UIWidgets.customAppBar(
                context: context,
                titleWidget: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomWidgets.buildUserInfo(
                    context: context,
                    userModel: receiverModel,
                    imageRadius: 20.0,
                    textColor: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ChatWidgets.buildMessage(
                            messageModel: chatsCubit.messages[index],
                            context: context,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            UIWidgets.vSeparator(),
                        itemCount: chatsCubit.messages.length,
                      ),
                    ),

                    // Write message
                    Row(
                      children: [
                        Expanded(
                          child: UIWidgets.customTextFormField(
                            context: context,
                            textController: messageController,
                            borderRadius: 10.0,
                            hint: 'Write a message...',
                          ),
                        ),

                        // Send button
                        IconButton(
                          onPressed: () {
                            ChatsCubit.getChatsCubit(context).sendMessage(
                              receiverId: receiverModel.uid!,
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
          },
        );
      },
    );
  }
}
