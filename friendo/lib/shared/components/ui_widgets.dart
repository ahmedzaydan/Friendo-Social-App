import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friendo/modules/posts/components.dart/post_widgets.dart';

import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../modules/posts/cubit/post_cubit.dart';
import '../../modules/posts/cubit/post_states.dart';
import 'constants.dart';
import 'custom_widgets.dart';

class UIWidgets {
  static AppBar customAppBar({
    required BuildContext context,
    String title = '',
    Widget? titleWidget,
    List<Widget>? actions,
    bool hasLeading = true,
  }) {
    return AppBar(
      title: titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
      leading: hasLeading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
            )
          : null,
      actions: actions,
    );
  }

  static Widget customMaterialButton({
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
      width: width,
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
                    backgroundColor: backgroundColor,
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
    double borderRadius = 15.0,
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
        // hintStyle: Theme.of(context).textTheme.bodyLarge,
        prefixIcon: prefixIcon,
        labelText: hint,
        // label: Text(hint),
        // hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //       color: Colors.grey,
        //     ),
        suffixIcon: suffixIcon,
        border: disableBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
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
    required bool isLikeAction,
    Widget widget = const SizedBox(),
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<PostCubit, PostStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final PostCubit postCubit = PostCubit.getPostCubit(context);
              List<dynamic> list = [];
              isLikeAction
                  ? list = postCubit.likers[postId]!
                  : list = postCubit.commentModels[postId]!.values.toList();
              UserModel authorModel =
                  postCubit.userModels[postCubit.postModels[postId]!.authorId]!;
              bool isCurrentUser = authorModel.uid == currentUserId;
              List<CommentModel> comments =
                  postCubit.commentModels[postId]!.values.toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Widget widgetToBuild;
                        isLikeAction
                            ? widgetToBuild = CustomWidgets.buildUserInfo(
                                context: context,
                                userModel: postCubit.userModels[
                                    postCubit.likers[postId]![index]]!,
                                isCurrentUser: isCurrentUser,
                              )
                            : widgetToBuild = PostWidgets.buildComment(
                                context: context,
                                commentModel: comments[index],
                                authorModel: authorModel,
                                isCurrentUser: isCurrentUser,
                              );
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: widgetToBuild,
                        );
                      },
                    ),
                  ),

                  widget,
                ],
              );
            },
          ),
        );
      },
    );
  }
}
