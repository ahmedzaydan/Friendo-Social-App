import 'package:flutter/material.dart';
import 'package:friendo/modules/posts/components.dart/post_widgets.dart';
import 'package:friendo/modules/posts/posts_screens/new_post_screen.dart';
import 'package:friendo/shared/styles/color.dart';

import '../../../layout/cubit/friendo_cubit.dart';
import '../../../shared/components/custom_widgets.dart';
import '../../../shared/components/ui_widgets.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostWidgets.buildPosts(
      context: context,
      appBar: CustomWidgets.buildAppBar(
        context: context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Camera icon
            CustomWidgets.buildIcon(
              icon: Icons.camera_alt_outlined,
            ),

            // Title
            Align(
              alignment: Alignment.center,
              child: Text(
                FriendoCubit.getFriendoCubit(context).bottomNavScreensTitles[
                    FriendoCubit.getFriendoCubit(context).currentIndex],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidgets.buildIcon(
                  icon: Icons.notifications_none_outlined,
                ),
                UIWidgets.hSeparator(width: 10),
                // Search icon
                CustomWidgets.buildIcon(
                  icon: Icons.search,
                ),
              ],
            ),
          ],
        ),
      ),
      widget: InkWell(
        onTap: () {
          UIWidgets.navigateTo(
            context: context,
            destination: NewPostScreen(),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color2,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            'What\'s on your mind, Friendo?',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.grey[900],
                ),
          ),
        ),
      ),
    );
  }
}
