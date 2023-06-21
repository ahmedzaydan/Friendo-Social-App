// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/chats_screen.dart';
import 'package:friendo/modules/new_post_screen.dart';
import 'package:friendo/modules/settings_screen.dart';
import 'package:friendo/modules/users_screen.dart';
import 'package:friendo/shared/components/classes/custom_toast.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/feeds_screen.dart';
import '../../shared/styles/icon_broken.dart';

class FriendoCubit extends Cubit<FriendoStates> {
  FriendoCubit() : super(FriendoInitialState());

  static FriendoCubit getFriendoCubit(context) {
    return BlocProvider.of(context);
  }

  late UserModel userModel;

  void getUserData() {
    usersDB.doc(uid!).get().then((documentSnapshot) {
      userModel = UserModel.fromJson(json: documentSnapshot.data()!);
      coverImageURL = userModel.coverImage!;
      profileImageURL = userModel.profileImage!;
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState(error.toString()));
    });
  }

  void verifyEmail() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
      usersDB.doc(uid!).update({
        'isEmailVerified': true,
      });
      getUserData();
      CustomToast.showToast(
        message: "Please check your mail",
        state: ToastStates.SUCCESS,
      );
      emit(VerifyEmailSuccessState());
    }).catchError((error) {
      print(error.toString());

      emit(VerifyEmailErrorState(error.toString()));
    });
  }

  void logout({
    required BuildContext context,
  }) {
    emit(LogoutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      CacheController.removeData(key: 'uid');
      emit(LogoutSuccessState());
    }).catchError((error) {
      emit(LogoutErrorState(error.toString()));
    });
  }

  int currentIndex = 0; // bottom nav bar index
  void changeCurrentIndex({
    required int index,
  }) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeCurrentIndexState());
    }
  }

  List<Widget> bottomNavBarScreens = const [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = const [
    // Home
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Home,
      ),
      label: 'Home',
    ),
    // Chats
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Chat,
      ),
      label: 'Chats',
    ),
    // New post
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Paper_Upload,
      ),
      label: 'Add',
    ),
    // Users
    BottomNavigationBarItem(
      icon: Icon(IconBroken.User),
      label: 'Users',
    ),
    // Settings
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Setting,
      ),
      label: 'Settings',
    ),
  ];

  // Cover image + profile image section
  ImagePicker picker = ImagePicker();
  late XFile pickedFile; // Used to pick actual image from gallery or camera

  File coverImage = noImageFile;
  String coverImageURL = noImageURL;

  File profileImage = noImageFile;
  String profileImageURL = noImageURL;

  void pickImage({
    required bool isProfile,
  }) {
    // Pick cover image from gallery
    picker.pickImage(source: ImageSource.gallery).then((value) {
      pickedFile = value!;
      // Assign the picked image to variable
      isProfile
          ? profileImage = File(pickedFile.path)
          : coverImage = File(pickedFile.path);
      print("pickedFile.path = ${pickedFile.path}");
      emit(PickImageSuccessState());
      getImageURL(
        isProfile: isProfile,
      );
    }).catchError((error) {
      emit(PickImageErrorState());
    });
  }

  void getImageURL({
    required bool isProfile,
  }) {
    // Specify the path of the image in firebase storage and store it in variable
    final imagePath = storageRef.child(isProfile
        ? 'users/profile/${Uri.file(profileImage.path).pathSegments.last}'
        : 'users/cover/${Uri.file(coverImage.path).pathSegments.last}');

    // Upload image to firebase storage
    imagePath
        .putFile(isProfile ? profileImage : coverImage)
        .then((takeSnapShot) {
      // Get image download URL
      takeSnapShot.ref.getDownloadURL().then((downloadURL) {
        // Store image download URL in variable
        isProfile ? profileImageURL = downloadURL : coverImageURL = downloadURL;
        emit(UploadImageSuccessState());
      }).catchError((error) {
        emit(GetDownloadURLErrorState());
      });
    }).catchError((error) {
      emit(UploadImageErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String bio,
    required String phone,
  }) {
    usersDB.doc(uid).update(
      {
        'name': name,
        'bio': bio,
        'phone': phone,
        'coverImage': coverImageURL,
        'profileImage': profileImageURL,
      },
    ).then((value) {
      getUserData();
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      emit(UpdateUserDataErrorState(error.toString()));
    });
  }
}
