import 'package:flutter/material.dart';
import 'package:friendo/modules/profile/profile_widgets.dart';

import '../../shared/components/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ProfileWidgets.buildProfileScreen(
      showAppBar: false,
      context: context,
      userModel: currentUserModel,
      isCurrentUser: true,
    );
  }
}
