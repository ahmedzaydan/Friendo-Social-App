// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/authentication/cubit/auth_states.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/shared/components/ui_widgets.dart';

import '../../../layout/cubit/friendo_cubit.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_controller.dart';
import '../login_screen.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit getAuthCubit(context) => BlocProvider.of(context);

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((userCredential) {
      emit(LoginSuccessState(userCredential.user!.uid));

      currentUserId = userCredential.user!.uid;
      FriendoCubit.getFriendoCubit(context).getCurrentUserModel();
      PostCubit.getPostCubit(context).getPostsInfo();
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  void register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((userCredential) {
      currentUserId = userCredential.user!.uid;
      createUser(
        username: username,
        uid: currentUserId!,
        email: email,
        phone: phone,
      );
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
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

  void createUser({
    required String uid,
    required String username,
    required String email,
    required String phone,
  }) {
    UserModel userModel = UserModel(
      uid: uid,
      username: username,
      email: email,
      phone: phone,
      profileImage: blankImageURL,
      coverImage: blankImageURL,
      bio: 'Write your bio...',
    );
    usersCollection.doc(uid).set(userModel.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
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

  void logout({
    required BuildContext context,
  }) async {
    try {
      emit(LogoutLoadingState());
      await FirebaseAuth.instance.signOut();
      CacheController.removeData(key: 'uid');
      // ignore: use_build_context_synchronously
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
