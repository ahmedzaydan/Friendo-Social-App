import 'package:flutter/material.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../models/user_model.dart';
import '../../modules/posts/components.dart/post_widgets.dart';

class CustomWidgets {
  static Widget buildUserInfo({
    required BuildContext context,
    required UserModel userModel,
    bool isCurrentUser = false,
    VoidCallback? onTap,
    double imageRadius = 15.0,
    Color textColor = Colors.black,
    double? fontSize,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Widget widget = PostWidgets.buildProfileScreen(
              context: context,
              userModel: userModel,
              isCurrentUser: isCurrentUser,
            );
            UIWidgets.navigateTo(
              context: context,
              destination: widget,
            );
          },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: imageRadius,
            backgroundImage: NetworkImage(
              userModel.profileImage!,
            ),
          ),
          UIWidgets.hSeparator(),
          Text(
            userModel.username!,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 16.0,
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}
