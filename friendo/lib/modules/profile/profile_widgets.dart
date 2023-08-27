import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendo/modules/posts/components.dart/post_widgets.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/components/custom_widgets.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../models/user_model.dart';
import '../../shared/styles/color.dart';

abstract class ProfileWidgets {
  static Widget buildProfileImage({
    required UserModel userModel,
    required BuildContext context,
    Color borderColor = Colors.black,
    Color? imageBackgroundColor,
    double borderWidth = 2.0,
    double innerRadius = 30.0,
    bool showUsername = false,
    VoidCallback? onTap,
  }) {
    imageBackgroundColor ?? Colors.transparent;
    return InkWell(
      onTap: onTap ??
          () {
            UIWidgets.navigateTo(
              context: context,
              destination: ProfileWidgets.buildProfileScreen(
                context: context,
                userModel: userModel,
                isCurrentUser: userModel.uId == currentUId,
                showAppBar: false,
              ),
            );
          },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: userModel.profileImage!,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  radius: innerRadius,
                  backgroundImage: NetworkImage(
                    userModel.profileImage!,
                  ),
                  backgroundColor: imageBackgroundColor,
                );
              },
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          if (showUsername)
            Text(
              userModel.username!,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  static Widget buildProfileScreen({
    required BuildContext context,
    required UserModel userModel,
    bool isCurrentUser = false,
    bool showAppBar = true,
  }) {
    return Scaffold(
      body: Stack(
        children: [
          // Cover image
          Stack(
            children: [
              // Cover image
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: CachedNetworkImage(
                  imageUrl: userModel.coverImage!,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            userModel.coverImage!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // AppBar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomWidgets.buildIcon(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: color1.withAlpha(130),
                ),
              )
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 25,
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.7,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  // Profile info
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1K Followers',
                      ),
                      Spacer(),
                      Text(
                        '342 Following',
                      ),
                    ],
                  ),

                  UIWidgets.vSeparator(height: 100),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Follow button
                      UIWidgets.customMaterialButton(
                        onPressed: () {},
                        text: 'Follow',
                        context: context,
                        width: 100,
                        height: 45,
                        radius: 30,
                        backgroundColor: color4,
                      ),

                      // Message button
                      UIWidgets.customMaterialButton(
                        onPressed: () {},
                        text: 'Message',
                        context: context,
                        width: 100,
                        height: 45,
                        radius: 30,
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),

                      // Edit profile button
                      if (isCurrentUser)
                        UIWidgets.customMaterialButton(
                          onPressed: () {},
                          text: 'Edit Profile',
                          context: context,
                          width: 120,
                          height: 45,
                          radius: 30,
                          backgroundColor: color4,
                        ),
                    ],
                  ),

                  UIWidgets.vSeparator(height: 20),

                  // Posts
                  Expanded(
                    child: PostWidgets.buildPosts(
                      context: context,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.1,
            left: MediaQuery.sizeOf(context).width / 2 - 60,
            // right:
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileImage(
                  context: context,
                  userModel: userModel,
                  innerRadius: 60,
                  showUsername: true,
                ),
                // Bio
                Text(
                  userModel.bio!,
                ),
              ],
            ),
          ),
          // // Buttons
          // if (isCurrentUser)
          //   Row(
          //     children: [
          //       Expanded(
          //         child: UIWidgets.customMaterialButton(
          //           onPressed: () {
          //             UIWidgets.navigateTo(
          //               context: context,
          //               destination: NewPostScreen(),
          //             );
          //           },
          //           text: "Add post",
          //           context: context,
          //           isUpperCase: true,
          //         ),
          //       ),
          //       UIWidgets.hSeparator(),
          //       Expanded(
          //         child: UIWidgets.customMaterialButton(
          //           onPressed: () {
          //             UIWidgets.navigateTo(
          //               context: context,
          //               destination: EditProfileScreen(),
          //             );
          //           },
          //           text: "Edit profile",
          //           context: context,
          //           isUpperCase: true,
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
