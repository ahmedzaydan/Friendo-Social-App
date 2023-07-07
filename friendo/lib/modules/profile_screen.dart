import 'package:flutter/material.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/components/post_widgets.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  Widget? widget;
  ProfileScreen({super.key, Widget? widget});
  @override
  Widget build(BuildContext context) {
    return widget ??
        PostWidgets.buildProfileScreen(
          showAppBar: false,
          context: context,
          userModel: currentUserModel!,
          isCurrentUser: true,
        );
  }
}
