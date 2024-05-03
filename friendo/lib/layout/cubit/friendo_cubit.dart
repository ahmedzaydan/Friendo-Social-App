import 'dart:async';
import 'dart:io';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/profile/profile_screen.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/chats/chats_screen.dart';
import '../../modules/other_pages/settings_screen.dart';
import '../../modules/posts/posts_screens/feeds_screen.dart';

class FriendoCubit extends Cubit<FriendoStates> {
  FriendoCubit() : super(FriendoInitialState());

  static FriendoCubit getFriendoCubit(context) {
    return BlocProvider.of(context);
  }

  Stream<UserModel> getUserModel({
    required String userId,
    bool isCurrentUser = false,
  }) {
    var streamController = StreamController<UserModel>();
    usersCollection.doc(userId).snapshots().listen((event) {
      UserModel userModel = UserModel.fromJson(
        json: event.data()!,
      );
      streamController.add(userModel);
      if (isCurrentUser) {
        currentUserModel = userModel;
        coverImageURL = currentUserModel.coverImage!;
        profileImageURL = currentUserModel.profileImage!;
      }
    }, onError: (error) {
      streamController.addError(error.toString());
    });
    return streamController.stream;
  }

  Stream<Map<String, UserModel>> getUserModels() {
    var streamController = StreamController<Map<String, UserModel>>();
    usersCollection.snapshots().listen(
      (event) {
        Map<String, UserModel> userModels = {};
        for (var document in event.docs) {
          userModels[document.id] = UserModel.fromJson(
            json: document.data(),
          );
        }
        streamController.add(userModels);
      },
      onError: (error) {
        streamController.addError(error);
      },
    );
    return streamController.stream;
  }

  /// Cover image + profile image section
  ImagePicker picker = ImagePicker();

  File coverImage = File(blankImageURL);
  String coverImageURL = blankImageURL;

  File profileImage = File(blankImageURL);
  String profileImageURL = blankImageURL;

  final String initImagePath = 'users/$currentUId';

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
      await usersCollection.doc(currentUId).update({
        'coverImage': coverImageURL != blankImageURL
            ? coverImageURL
            : currentUserModel.coverImage!,
        'profileImage': profileImageURL != blankImageURL
            ? profileImageURL
            : currentUserModel.profileImage!,
      });
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
      await usersCollection.doc(currentUId).update(
        {
          'username': username ?? currentUserModel.username,
          'bio': bio ?? currentUserModel.bio,
          'phone': phone ?? currentUserModel.phone,
        },
      );
      emit(UpdateUserDataSuccessState());
    } catch (error) {
      emit(UpdateUserDataErrorState());
    }
  }

  /// Bottom nav bar section **********************************************************************************

  // bottom nav bar index
  int currentIndex = 0;

  void changeCurrentIndex({
    required int index,
    required BuildContext context,
  }) {
    currentIndex = index;
    emit(ChangeCurrentIndexState());
  }

  List<String> bottomNavScreensTitles = const [
    'Feeds',
    'Chats',
    // 'Add Post',
    'Profile',
    'Settings',
  ];
  List<Widget> bottomNavBarScreens = [
    const FeedsScreen(),
    const ChatsScreen(),
    // NewPostScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  static const TextStyle bottomNavBarTextStyle = TextStyle(
    color: Colors.white,
  );
  static const iconColor = Colors.white;
  List<CurvedNavigationBarItem> bottomNavBarItems = [
    const CurvedNavigationBarItem(
      child: Icon(
        Icons.home,
        color: iconColor,
      ),
      label: 'Feeds',
      labelStyle: bottomNavBarTextStyle,
    ),
    const CurvedNavigationBarItem(
      child: Icon(
        Icons.chat,
        color: iconColor,
      ),
      label: 'Chats',
      labelStyle: bottomNavBarTextStyle,
    ),
    const CurvedNavigationBarItem(
      child: Icon(
        Icons.person,
        color: iconColor,
      ),
      label: 'Profile',
      labelStyle: bottomNavBarTextStyle,
    ),
    const CurvedNavigationBarItem(
      child: Icon(
        Icons.settings,
        color: iconColor,
      ),
      label: 'Settings',
      labelStyle: bottomNavBarTextStyle,
    ),
  ];
}
