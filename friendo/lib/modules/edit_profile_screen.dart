import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/shared/components/classes/custom_appbar.dart';
import 'package:friendo/shared/components/classes/custom_text_form_field.dart';
import 'package:friendo/shared/components/classes/custom_utilities.dart';
import 'package:friendo/shared/styles/icon_broken.dart';

import '../layout/cubit/freindo_states.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendoCubit, FriendoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);
        UserModel userModel = friendoCubit.userModel;
        nameController.text = userModel.username!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: CustomAppBar.customAppBar(
            context: context,
            title: "Edit Profile",
            actions: [
              TextButton(
                onPressed: () {
                  friendoCubit.updateUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Cover + Profile photo
                  SizedBox(
                    height: 190,
                    child: Stack(
                      children: [
                        // Cover + cover camera icon
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Cover
                            Container(
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

                            // Cover camera icon
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  friendoCubit.pickImage(
                                    isProfile: false,
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Profile photo + profile camera icon
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // Profile photo
                              CircleAvatar(
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

                              // Profile camera icon
                              TextButton(
                                onPressed: () {
                                  friendoCubit.pickImage(
                                    isProfile: true,
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  CustomUtilities.vSeparator(),

                  // Edit name
                  CustomTextFormField.textFormField(
                    textController: nameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(
                      IconBroken.User,
                    ),
                    label: "Name",
                    validator: (name) {
                      if (name!.isEmpty) {
                        return "Name must not be empty";
                      }
                      return null;
                    },
                    context: context,
                  ),

                  // Edit bio
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: CustomTextFormField.textFormField(
                      textController: bioController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        IconBroken.Info_Circle,
                      ),
                      label: "Bio",
                      validator: (name) {
                        return null;
                      },
                      context: context,
                    ),
                  ),

                  // Edit phone number
                  CustomTextFormField.textFormField(
                    textController: phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      IconBroken.Call,
                    ),
                    label: "Phone",
                    validator: (name) {
                      if (name!.isEmpty) {
                        return "Phone number must not be empty";
                      }
                      return null;
                    },
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
