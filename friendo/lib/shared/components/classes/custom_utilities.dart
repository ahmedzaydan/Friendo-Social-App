// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

class CustomUtilities {
  // navigator function
  static void navigateTo({
    required dynamic context,
    required Widget destination,
    bool pushAndFinish = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => destination,
        maintainState: !pushAndFinish,
      ),
    );
  }

  static Widget vSeparator({
    double height = 10.0,
  }) {
    return SizedBox(
      height: height,
    );
  }

  static Widget hSeparator({
    double width = 10.0,
  }) {
    return SizedBox(
      width: width,
    );
  }
}
