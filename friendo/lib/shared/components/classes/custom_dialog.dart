import 'package:flutter/material.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';

import '../../../modules/authentication/login_screen.dart';
import 'custom_utilities.dart';

class CustomDialog {
  static Future<void> customDialog({
    required String title,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: const SingleChildScrollView(
            child: null,
          ),
          actions: [
            // Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                // Ok
                TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Ok",
                  ),
                ),
              ],
            ),


          ],
        );
      },
    );
  }
}
