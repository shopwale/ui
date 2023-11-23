import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';

MaterialButton CustomFilledButton(
  BuildContext context, {
  String text = "",
  VoidCallback? onPressed,
  bool showLoader = false,
  Color color = Colors.green,
  int screenWidth = 1,
  double fontSize = 18,
}) =>
    MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: color,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      height: 40.0,
      minWidth: (MediaQuery.of(context).size.width / screenWidth) - 40,
      disabledColor: color.withOpacity(0.5),
      color: color,
      textColor: Colors.white,
      onPressed: showLoader == true ? null : onPressed,
      splashColor: Colors.redAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(letterSpacing: 1.5, fontSize: fontSize),
          ),
          if (showLoader == true) ...[
            const SizedBox(width: 10),
            const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Colors.white),
            )
          ]
        ],
      ),
    );
