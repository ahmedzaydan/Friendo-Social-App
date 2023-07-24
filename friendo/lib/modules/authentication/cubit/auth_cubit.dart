// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/authentication/cubit/auth_states.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_controller.dart';
import '../login_screen.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit getAuthCubit(context) => BlocProvider.of(context);

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      emit(LoginLoadingState());
      var userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUId = userCredential.user!.uid;
      var deviceToken = await FirebaseMessaging.instance.getToken();

      // Update device token in user model
      await usersCollection.doc(currentUId).update({
        'deviceToken': deviceToken,
      });
      emit(LoginSuccessState(userCredential.user!.uid));
    } catch (error) {
      emit(LoginErrorState(error.toString()));
    }
  }

  Future<void> createUser({
    required String uid,
    required String deviceToken,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      UserModel userModel = UserModel(
        uId: uid,
        deviceToken: deviceToken,
        username: username,
        email: email,
        phone: phone,
        profileImage: blankImageURL,
        coverImage: blankImageURL,
        bio: 'Write your bio...',
      );
      await usersCollection.doc(uid).set(userModel.toMap());
      emit(CreateUserSuccessState());
    } catch (error) {
      emit(CreateUserErrorState(error.toString()));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      emit(RegisterLoadingState());
      var userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUId = userCredential.user!.uid;
      var deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken != null) {
        createUser(
          uid: currentUId!,
          deviceToken: deviceToken,
          username: username,
          email: email,
          phone: phone,
        );
        emit(RegisterSuccessState(userCredential.user!.uid));
      }
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
    }
  }

  bool checkPassword({
    required String password,
  }) {
    return false;
  }

  bool isPassword = true;
  Icon passwordSuffix = const Icon(Icons.visibility_outlined);

  void changePasswordVisibility() {
    isPassword = !isPassword;
    if (isPassword) {
      passwordSuffix = const Icon(Icons.visibility_outlined);
    } else {
      passwordSuffix = const Icon(Icons.visibility_off_outlined);
    }
    emit(ChangePasswordVisibilityState());
  }

  void verifyEmail({
    required BuildContext context,
  }) {
    /*FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);

    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
      usersDB.doc(uid!).update({
        'isEmailVerified': true,
      });
      CustomToast.showToast(
        message: "Please check your mail",
        state: ToastStates.SUCCESS,
      );
      emit(VerifyEmailSuccessState());
      friendoCubit.getUserData();
    }).catchError((error) {
      emit(VerifyEmailErrorState(error.toString()));
    });*/
  }

  Future<void> logout({
    required BuildContext context,
  }) async {
    try {
      emit(LogoutLoadingState());
      await FirebaseAuth.instance.signOut();
      CacheController.removeData(key: 'uid');
      UIWidgets.navigateTo(
        context: context,
        destination: LoginScreen(),
      );
      emit(LogoutSuccessState());
    } catch (error) {
      emit(LogoutErrorState(error.toString()));
      UIWidgets.showCustomToast(
        message: error.toString(),
        state: ToastStates.ERROR,
      );
    }
  }
}
