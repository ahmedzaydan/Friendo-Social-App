import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friendo/shared/styles/color.dart';

import '../../models/user_model.dart';
import '../../modules/posts/components.dart/post_widgets.dart';
import 'constants.dart';
import 'custom_widgets.dart';

class UIWidgets {
  static Widget customMaterialButton({
    double width = double.infinity,
    double height = 50.0,
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
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: useTextTheme
              ? Theme.of(context).textTheme.bodyLarge
              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                    backgroundColor: Colors.transparent,
                  ),
        ),
      ),
    );
  }

  static Widget customTextFormField({
    required BuildContext context,
    TextEditingController? textController,
    String label = '',
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    Icon? prefixIcon,
    String? Function(String?)? validator,
    bool isPassword = false,
    IconButton? suffixIcon,
    String hint = '',
    Function(String value)? myOnFieldSubmitted,
    Function(String value)? myOnChanged,
    VoidCallback? myOnTap,
    double bottomRightRadius = 15.0,
    double bottomLeftRadius = 15.0,
    double topRightRadius = 15.0,
    double topLeftRadius = 15.0,
    bool? myEnabled,
    bool disableBorder = false,
    int? maxLines,
    bool autofocus = false,
  }) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      controller: textController,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: isPassword,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hint,
        border: disableBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius),
                  topRight: Radius.circular(topRightRadius),
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  bottomRight: Radius.circular(bottomRightRadius),
                ),
              ),
      ),
      onFieldSubmitted: myOnFieldSubmitted,
      onChanged: myOnChanged,
      onTap: myOnTap,
      enabled: myEnabled,
      autofocus: autofocus,
    );
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    String title = '',
    Widget? child,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Center(
            child: Text(
              title,
            ),
          ),
          content: SizedBox(
            width: 10,
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  static Future<void> showImageDialog({
    required void Function()? galleryOnPressed,
    required void Function()? cameraOnPressed,
    required BuildContext context,
  }) {
    return showCustomDialog(
      context: context,
      title: "Choose Image",
      child: Column(
        children: [
          // Choose from gallery
          TextButton(
            onPressed: galleryOnPressed,
            child: const Text(
              "Gallery",
            ),
          ),

          vSeparator(),

          // Choose from camera
          TextButton(
            onPressed: cameraOnPressed,
            child: const Text(
              "Camera",
            ),
          ),
        ],
      ),
    );
  }

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
  static void showCustomToast({
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

  static Widget vSeparator({double height = 10.0}) => SizedBox(height: height);

  static Widget hSeparator({double width = 10.0}) => SizedBox(width: width);

  static void customShowModalBottomSheet({
    required BuildContext context,
    required String postId,
    required UserModel authorModel,
    required bool isLikeAction,
    Widget widget = const SizedBox(),
  }) {
    bool isCurrentUser = authorModel.uId == currentUId;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: color1,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidgets.buildCloseButton(),
              Expanded(
                child: isLikeAction
                    ? PostWidgets.buildPostLikers(
                        postId: postId,
                        isCurrentUser: isCurrentUser,
                        context: context,
                      )
                    : PostWidgets.buildPostComments(
                        postId: postId,
                        isCurrentUser: isCurrentUser,
                        context: context,
                      ),
              ),
              widget,
            ],
          ),
        );
      },
    );
  }
}
