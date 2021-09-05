import 'package:flutter/material.dart';

Future<dynamic> showLoadingOverlay(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
