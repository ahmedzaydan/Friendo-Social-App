import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class CustomToast {
    static Color colorToast(ToastStates state) {
    Color color;
    if (state == ToastStates.SUCCESS) {
      color = Colors.green;
    } else if (state == ToastStates.ERROR) {
      color = Colors.red;
    } else {
      color = Colors.amber;
    }
    return color;
  }

  // custom showToast
  static void showToast({
    required String message,
    required ToastStates state,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: colorToast(state),
      textColor: Colors.white,
      fontSize: 18,
    );
  }
}