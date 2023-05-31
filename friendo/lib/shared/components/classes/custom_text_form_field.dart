import 'package:flutter/material.dart';

class CustomTextFormField {
  // custom TextFormField
  static Widget textFormField({
    required TextEditingController textController,
    required TextInputType keyboardType,
    required Icon prefixIcon,
    required String label,
    required Function(String?) validator,
    required BuildContext context,
    bool isPassword = false,
    IconButton? suffixIcon,
    Function(String value)? myOnFieldSubmitted,
    Function(String value)? myOnChanged,
    VoidCallback? myOnTap,
    double borderRadius = 15.0,
    bool myEnabled = true,
  }) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      controller: textController,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: (String? value) => validator(value),
      decoration: InputDecoration(
        // hintStyle: Theme.of(context).textTheme.bodyLarge,
        prefixIcon: prefixIcon,
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onFieldSubmitted: myOnFieldSubmitted,
      onChanged: myOnChanged,
      onTap: myOnTap,
      enabled: myEnabled,
      autofocus: true,
    );
  }

}