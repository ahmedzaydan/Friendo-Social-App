import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/shared/components/classes/custom_utilities.dart';

import '../modules/new_post_screen.dart';
import '../shared/styles/icon_broken.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendoCubit, FriendoStates>(
      listener: (context, state) {
        if (state is NewPostState) {
          CustomUtilities.navigateTo(
            context: context,
            destination: const NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Home Layout Screen",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              centerTitle: true,
              actions: [
                // logout button
                // IconButton(
                //   onPressed: () {
                //     CustomDialog.customDialog(
                //       title: "Are you sure you want to logout?",
                //       context: context,
                //       onPressed: () {
                //         friendoCubit.logout(context: context);
                //         CustomUtilities.navigateTo(
                //           context: context,
                //           destination: LoginScreen(),
                //         );
                //       },
                //     );
                //   },
                //   icon: const Icon(
                //     IconBroken.Logout,
                //   ),
                // ),

                // notification button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconBroken.Notification),
                ),
                CustomUtilities.hSeparator(
                  width: 5,
                ),
                // search button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconBroken.Search),
                ),
              ],
            ),
            body: friendoCubit.bottomNavBarScreens[friendoCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: friendoCubit.currentIndex,
              onTap: (index) {
                friendoCubit.changeCurrentIndex(index: index);
              },
              items: friendoCubit.bottomNavBarItems,
            ));
      },
    );
  }
}

/*Column(
                children: [
                  // if (!FirebaseAuth.instance.currentUser!.emailVerified)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Your email is not verified!",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        CustomUtilities.hSeparator(),
                        TextButton(
                          onPressed: () {
                            friendoCubit.verifyEmail();
                            CustomUtilities.navigateTo(
                              context: context,
                              destination: LoginScreen(),
                            );
                          },
                          child: Text(
                            "Verify",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.blue,
                                    ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )*/
