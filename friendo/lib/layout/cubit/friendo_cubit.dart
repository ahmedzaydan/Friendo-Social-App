// ignore_for_file: avoid_print
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/profile_screen.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/chats/chats_screen.dart';
import '../../modules/chats/cubit/chats_cubit.dart';
import '../../modules/posts/cubit/post_cubit.dart';
import '../../modules/posts/posts_screens/feeds_screen.dart';
import '../../modules/settings_screen.dart';
import '../../modules/users_screen.dart';
import '../../shared/styles/icon_broken.dart';

class FriendoCubit extends Cubit<FriendoStates> {
  FriendoCubit() : super(FriendoInitialState());

  static FriendoCubit getFriendoCubit(context) {
    return BlocProvider.of(context);
  }

  void getCurrentUserModel() async {
    try {
      var documentSnapshot = await usersCollection.doc(currentUserId).get();
      currentUserModel = UserModel.fromJson(json: documentSnapshot.data()!);
      coverImageURL = currentUserModel!.coverImage!;
      profileImageURL = currentUserModel!.profileImage!;
      emit(GetCurrentUserModelSuccessState());
    } catch (error) {
      emit(GetCurrentUserModelErrorState(error.toString()));
    }
  }

  int currentIndex = 0; // bottom nav bar index

  void changeCurrentIndex({
    required int index,
    required BuildContext context,
  }) {
    if (index == 0) {
      PostCubit.getPostCubit(context).getPostsInfo();
    } else if (index == 1) {
      ChatsCubit.getChatsCubit(context).getUsers();
    }
    currentIndex = index;
    emit(ChangeCurrentIndexState());
  }

  // Cover image + profile image section
  ImagePicker picker = ImagePicker();

  File coverImage = File(blankImageURL);
  String coverImageURL = blankImageURL;

  File profileImage = File(blankImageURL);
  String profileImageURL = blankImageURL;

  final String initImagePath = 'users/$currentUserId';

  // Upload profile/cover image
  void uploadImage({
    bool fromGallery = true,
    bool isProfile = false,
  }) async {
    emit(UploadImageLoadingState());
    // Pick image
    final File imageFile = await pickImage(fromGallery: fromGallery);
    isProfile ? profileImage = imageFile : coverImage = imageFile;

    // Get image download URL
    final String imageURL = await uploadToStorage(
      imagePath: initImagePath + (isProfile ? '/profile' : '/cover'),
      imageFile: isProfile ? profileImage : coverImage,
    );
    isProfile ? profileImageURL = imageURL : coverImageURL = imageURL;

    updateImage(); // Send image download URL to Firebase Firestore
  }

  Future<File> pickImage({
    bool fromGallery = true,
  }) async {
    File pickedImage = File('');
    // Pick image from gallery or camera
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
    } else {
      emit(PickImageErrorState());
    }
    return pickedImage;
  }

  Future<String> uploadToStorage({
    required String imagePath,
    required File imageFile,
  }) async {
    String imageURL = '';

    // Create a reference to the image file in Firebase Storage
    final imageRef = storageRef.child(
      '$initImagePath/$imagePath/${Uri.file(imageFile.path).pathSegments.last}',
    );

    // Upload image to Firebase storage
    final taskSnapshot = await imageRef.putFile(imageFile);

    if (taskSnapshot.state == TaskState.success) {
      // Get image download URL
      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      if (downloadURL.isNotEmpty) {
        imageURL = downloadURL;
      } else {
        emit(GetDownloadURLErrorState());
      }
    } else {
      emit(PutImageInStorageErrorState());
    }
    return imageURL;
  }

  // Send image download URL to Firebase Firestore
  void updateImage() async {
    try {
      await usersCollection.doc(currentUserId).update({
        'coverImage': coverImageURL != blankImageURL
            ? coverImageURL
            : currentUserModel!.coverImage!,
        'profileImage': profileImageURL != blankImageURL
            ? profileImageURL
            : currentUserModel!.profileImage!,
      });
      getCurrentUserModel();
    } catch (error) {
      emit(UpdateImageErrorState());
    }
  }

  void updateUserData({
    String? username,
    String? bio,
    String? phone,
  }) async {
    try {
      await usersCollection.doc(currentUserId).update(
        {
          'username': username ?? currentUserModel!.username,
          'bio': bio ?? currentUserModel!.bio,
          'phone': phone ?? currentUserModel!.phone,
        },
      );
      emit(UpdateUserDataSuccessState());
      getCurrentUserModel();
    } catch (error) {
      emit(UpdateUserDataErrorState());
    }
  }

  // BottomNavBar section
  List<Widget> bottomNavBarScreens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const UsersScreen(),
    ProfileScreen(),
    const SettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.chat,
      ),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.User,
      ),
      label: 'Users',
    ),

    // New post
    BottomNavigationBarItem(
      icon: Icon(
        Icons.person,
      ),
      label: 'Profile',
    ),

    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      label: 'Settings',
    ),
  ];
}
