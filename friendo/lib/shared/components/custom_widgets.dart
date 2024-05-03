import 'package:flutter/material.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../models/user_model.dart';
import '../../modules/profile/profile_widgets.dart';
import '../styles/color.dart';

abstract class CustomWidgets {
  static Widget buildUserInfo({
    required BuildContext context,
    required UserModel userModel,
    bool isCurrentUser = false,
    VoidCallback? onTap,
    double imageRadius = 25.0,
    Color textColor = Colors.black,
    double? fontSize,
    String? publishDate,
    double paddingH = 15.0,
    double paddingV = 10.0,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            // UIWidgets.navigateTo(
            //   context: context,
            //   destination: ProfileWidgets.buildProfileScreen(
            //     context: context,
            //     userModel: userModel,
            //     isCurrentUser: isCurrentUser,
            //     showAppBar: false,
            //   ),
            // );
          },
      child: Row(
        children: [
          ProfileWidgets.buildProfileImage(
            userModel: userModel,
            context: context,
            innerRadius: imageRadius,
          ),
          UIWidgets.hSeparator(),
          // Info
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.username!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize ?? 16.0,
                      color: textColor,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (publishDate != null)
                Text(
                  publishDate,
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildAppBar({
    required Widget child,
    double paddingH = 15.0,
    double paddingV = 10.0,
    required BuildContext context,
  }) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.12,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingH,
        vertical: paddingV,
      ),
      child: child,
    );
  }

  static Widget buildIcon({
    required IconData icon,
    Color iconColor = Colors.black,
    Color? backgroundColor,
    VoidCallback? onPressed,
    double radius = 25.0,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? color1,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }

  static Widget buildCloseButton() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 5,
        width: 50,
        margin: const EdgeInsets.only(
          top: 20.0,
          bottom: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  static Widget buildStreamBuilderWaiting() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget buildStreamBuilderError(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
    );
  }

  static Widget buildStreamBuilderNoData(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
    );
  }
}
