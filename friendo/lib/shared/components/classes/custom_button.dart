import 'package:flutter/material.dart';

class CustomButton {
    // custom button
  static Widget button({
    double width = double.infinity,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.blue,
    bool useTextTheme = false,
    bool isUpperCase = false,
    double radius = 15.0,
    double textSize = 20.0,
    required Function() onPressed,
    required String text,
    required BuildContext context,
  }) {
    return Container(
      // width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: useTextTheme
              ? Theme.of(context).textTheme.bodyLarge
              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                    backgroundColor: backgroundColor,
                  ),
        ),
      ),
    );
  }
}