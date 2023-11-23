import 'package:flutter/material.dart';

Widget CircularProgress({colors = Colors.green}) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: colors,
        ),
      ),
    );
