import 'package:flutter/material.dart';

// TODO(jeton): `Loader` should not expose static methods and keep in state if
// `SimpleDialog` is shown and avoid calling `pop` if it is not shown.
class Loader {
  static Future<void> startLoading(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return const SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }

  static void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> showError(BuildContext context, String error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text(error),
      ),
    );
  }
}
