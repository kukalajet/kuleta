import 'package:flutter/material.dart';

Future<void> startLoading(BuildContext context) async => showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return const SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );

void stopLoading(BuildContext context) => Navigator.of(context).pop();

Future<void> showError(BuildContext context, String error) async =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        backgroundColor: Colors.red,
        content: Text(error),
      ),
    );
