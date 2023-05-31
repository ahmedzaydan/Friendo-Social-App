// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

class CustomUtilities {
  
  // navigator function
  static void navigateTo({
    required BuildContext context,
    required Widget destination,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  static Widget vSeparator({
    double height = 15.0,
  }) {
    return SizedBox(
      height: height,
    );
  }

  static Widget hSeparator({
    double width = 15.0,
  }) {
    return SizedBox(
      width: width,
    );
  }
}
