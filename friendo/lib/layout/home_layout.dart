import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/shared/components/ui_widgets.dart';
import 'package:friendo/shared/styles/color.dart';

import '../modules/posts/posts_screens/new_post_screen.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendoCubit, FriendoStates>(
      listener: (context, state) {
        if (state is NewPostScreenState) {
          UIWidgets.navigateTo(
            context: context,
            destination: NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        var cubit = FriendoCubit.getFriendoCubit(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * 0.09,
                ),
                child: cubit.bottomNavBarScreens[cubit.currentIndex],
              ),
              // Curved bottom nav bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CurvedNavigationBar(
                  index: cubit.currentIndex,
                  items: cubit.bottomNavBarItems,
                  onTap: (index) {
                    cubit.changeCurrentIndex(
                      index: index,
                      context: context,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  color: color2,
                  buttonBackgroundColor: color4,
                  height: MediaQuery.sizeOf(context).height * 0.08,
                ),
              ),

              // if (
              //     cubit.currentIndex == 0 ||
              //       cubit.currentIndex == 2
              //     )
              //   Positioned(
              //     bottom: 80,
              //     right: 5,
              //     child: FloatingActionButton(
              //       backgroundColor: color5,
              //       shape: const CircleBorder(),
              //       onPressed: () {
              //         UIWidgets.navigateTo(
              //           context: context,
              //           destination: NewPostScreen(),
              //         );
              //       },
              //       child: const Icon(
              //         Icons.add,
              //         color: Colors.white,
              //         size: 35.0,
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
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


