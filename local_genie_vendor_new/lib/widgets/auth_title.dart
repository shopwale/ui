import 'package:flutter/material.dart';

Text TitleWidget(String text) => Text(
      text,
      style: const TextStyle(
          color: Colors.green,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );
