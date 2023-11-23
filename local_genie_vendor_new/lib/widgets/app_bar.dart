import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';

AppBar appBar(
  String text, {
  dynamic colors = darkBlue,
  List<Widget> actions = const [],
}) =>
    AppBar(
      foregroundColor: PrimarySwatch,
      title: Text(text),
      backgroundColor: colors,
      elevation: 0,
      actions: actions,
    );
