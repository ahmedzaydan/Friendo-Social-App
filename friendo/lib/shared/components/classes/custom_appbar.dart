import 'package:flutter/material.dart';

import '../../styles/icon_broken.dart';

class CustomAppBar {
  static AppBar customAppBar({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
  }) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          IconBroken.Arrow___Left_2,
        ),
      ),
      actions: actions,
    );
  }
}
