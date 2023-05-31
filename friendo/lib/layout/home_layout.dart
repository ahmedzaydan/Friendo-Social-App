import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/modules/authentication/login.dart';
import 'package:friendo/shared/components/custom_utilities.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendoCubit, FriendoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);
        // print(friendoCubit.user.toMap());
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Home Layout Screen",
            ),
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: friendoCubit.user != null,
            builder: (context) {
              return Column(
                children: [
                  if (!FirebaseAuth.instance.currentUser!.emailVerified)
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.blue,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              );
            },
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
