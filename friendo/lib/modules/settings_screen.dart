import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/modules/edit_profile_screen.dart';
import 'package:friendo/shared/components/classes/custom_utilities.dart';

import '../shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendoCubit, FriendoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var friendoCubit = FriendoCubit.getFriendoCubit(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Cover + Profile photo
              SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    // Cover
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              friendoCubit.coverImageURL,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Profile photo
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            friendoCubit.profileImageURL,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Name
              Text(
                friendoCubit.userModel.username!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              // Bio
              Text(
                friendoCubit.userModel.bio!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              // Statistics
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    // Posts
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '100',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Text(
                            'Posts',
                          ),
                        ],
                      ),
                    ),

                    // Photos
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '200',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Text(
                            'Photos',
                          ),
                        ],
                      ),
                    ),

                    // Followers
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '1K',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Text(
                            'Followers',
                          ),
                        ],
                      ),
                    ),

                    // Followings
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '100K',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Text(
                            'Followings',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Add Photos',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                  CustomUtilities.hSeparator(),
                  OutlinedButton(
                    onPressed: () {
                      CustomUtilities.navigateTo(
                        context: context,
                        destination: EditProfileScreen(),
                      );
                    },
                    child: Icon(
                      IconBroken.Edit,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
