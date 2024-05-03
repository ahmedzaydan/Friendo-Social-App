import 'package:flutter/material.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../models/user_model.dart';
import '../../shared/components/custom_widgets.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserModel>>(
      stream: FriendoCubit.getFriendoCubit(context).getUserModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error',
            ),
          );
        }

        // Data is available
        List<UserModel> users = snapshot.data!.values.toList();

        if (users.length < 2) {
          return CustomWidgets.buildStreamBuilderNoData('No users yet');
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            if (users[index].uId != currentUId) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomWidgets.buildUserInfo(
                  context: context,
                  userModel: users[index],
                  imageRadius: 35,
                  onTap: () {
                    UIWidgets.navigateTo(
                      context: context,
                      destination: ChatScreen(
                        receiverModel: users[index],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const SizedBox(
                height: 0,
              );
            }
          },
          itemCount: users.length,
        );
      },
    );
  }
}
