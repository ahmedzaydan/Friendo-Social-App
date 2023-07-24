import 'package:flutter/material.dart';
import 'package:friendo/modules/profile/profile_widgets.dart';

import '../../shared/components/constants.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  Widget? widget;
  ProfileScreen({super.key, Widget? widget});
  @override
  Widget build(BuildContext context) {
    return widget ??
        ProfileWidgets.buildProfileScreen(
          showAppBar: false,
          context: context,
          userModel: currentUserModel,
          isCurrentUser: true,
        );
  }
}
