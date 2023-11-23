import 'package:flutter/material.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';

MaterialButton CustomBorderButton(
  BuildContext context, {
  String text = "",
  VoidCallback? onPressed,
  bool showLoader = false,
  Color color = Colors.green,
  int screenWidth = 1,
  double fontSize = 18,
}) {
  return MaterialButton(
    height: 40.0,
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 22.0),
    minWidth: (MediaQuery.of(context).size.width / screenWidth) - 40,
    color: Colors.transparent,
    textColor: color,
    onPressed: showLoader == true ? null : onPressed,
    splashColor: Colors.white,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    visualDensity: VisualDensity.compact,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
      side: BorderSide(
        color: color,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text.toUpperCase(),
          style: TextStyle(letterSpacing: 1.5, fontSize: fontSize),
        ),
        if (showLoader) CircularProgress(),
      ],
    ),
  );
}
