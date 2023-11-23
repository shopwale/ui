import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String message;
  final int? seconds;

  const GlobalSnackBar({required this.message, this.seconds});

  static show(BuildContext context, String message, {int seconds = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: Duration(seconds: seconds),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        backgroundColor: Colors.black87,
        action: SnackBarAction(
          textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
