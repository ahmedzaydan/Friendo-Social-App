import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../modules/posts/posts_screens/new_post_screen.dart';
import '../temp.dart';

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
        FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);
        return Scaffold(
            appBar: UIWidgets.customAppBar(
              context: context,
              title: "Home Layout Screen",
              hasLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    UIWidgets.navigateTo(
                        context: context, destination: const Temp());
                  },
                  icon: const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                UIWidgets.hSeparator(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: friendoCubit.bottomNavBarScreens[friendoCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: friendoCubit.currentIndex,
              onTap: (index) {
                friendoCubit.changeCurrentIndex(
                  index: index,
                  context: context,
                );
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
