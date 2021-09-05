import 'package:flutter/material.dart';

void showError(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(minutes: 1),
      content: Text(errorMessage, softWrap: true),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    ),
  );
}
