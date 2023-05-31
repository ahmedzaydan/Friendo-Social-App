// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/freindo_states.dart';
import 'package:friendo/models/user_model.dart';
import 'package:friendo/shared/components/classes/custom_toast.dart';
import 'package:friendo/shared/components/custom_utilities.dart';
import 'package:friendo/shared/components/constants.dart';

class FriendoCubit extends Cubit<FriendoStates> {
  FriendoCubit() : super(FriendoInitialState());
  static FriendoCubit getFriendoCubit(context) {
    return BlocProvider.of(context);
  }

  UserModel? user;
  void getUserData() {
    usersDB.doc(uid!).get().then((documentSnapshot) {
      user = UserModel.fromJson(json: documentSnapshot.data()!);

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
}
