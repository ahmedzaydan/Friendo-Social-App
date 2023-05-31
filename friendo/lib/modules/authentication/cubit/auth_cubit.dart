// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/modules/authentication/cubit/auth_states.dart';

import '../../../shared/components/constants.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit getAuthCubit(context) => BlocProvider.of(context);

  void login({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((userCredential) {
      emit(LoginSuccessState(userCredential.user!.uid));
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
      uid = userCredential.user!.uid;
      createUser(
        username: username,
        uid: uid!,
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
    required String username,
    required String uid,
    required String email,
    required String phone,
  }) {
    UserModel userModel = UserModel(
      username: username,
      uid: uid,
      email: email,
      phone: phone,
    );
    usersDB.doc(uid).set(userModel.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
