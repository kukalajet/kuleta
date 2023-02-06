import 'package:flutter/material.dart';
import 'package:kuleta/features/app/app.dart';

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

void showError(String error) =>
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.red,
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Text(error),
          ],
        ),
      ),
    );
