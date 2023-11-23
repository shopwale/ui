import 'package:flutter/material.dart';

Widget SubTitleWidget(String text) => Padding(
    padding: const EdgeInsets.only(right: 60.0, top: 10),
    child: Text(text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        )));
