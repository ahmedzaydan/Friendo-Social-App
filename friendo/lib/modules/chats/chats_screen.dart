import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/chats/cubit/chats_cubit.dart';
import 'package:friendo/modules/chats/cubit/chats_states.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../shared/components/custom_widgets.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocConsumer<ChatsCubit, ChatsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final ChatsCubit chatsCubit = ChatsCubit.getChatsCubit(context);
            return ConditionalBuilder(
              condition: chatsCubit.users.isNotEmpty,
              builder: (context) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return CustomWidgets.buildUserInfo(
                      context: context,
                      imageRadius: 25.0,
                      onTap: () {
                        UIWidgets.navigateTo(
                            context: context,
                            destination: ChatScreen(
                              receiverModel: chatsCubit.users[index],
                            ));
                      },
                      userModel: chatsCubit.users[index],
                    );
                  },
                  separatorBuilder: (context, index) => UIWidgets.vSeparator(),
                  itemCount: chatsCubit.users.length,
                );
              },
              fallback: (context) => const CircularProgressIndicator(),
            );
          }),
    );
  }
}
