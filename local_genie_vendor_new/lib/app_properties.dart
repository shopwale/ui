import 'package:flutter/material.dart';

const Color yellow = Color(0xff082e53);
const Color mediumBlue = Color.fromRGBO(12, 85, 158, 1);
const Color darkBlue = Color.fromARGB(255, 0, 34, 67);
const Color transparentBlue = Color.fromRGBO(12, 85, 158, 0.7);
const Color darkGrey = Color(0xff202020);
const Color lightGrey = Color.fromARGB(255, 187, 187, 187);
const Color primary = Color(0xff082e53);

// const

const MaterialColor PrimarySwatch = MaterialColor(0xffFDB846, {
  50: Color(0xffEEC172),
  100: Color(0XFFEDBF6E),
  200: Color(0XFFECBC69),
  300: Color(0xffF1BF68),
  400: Color(0xffFDB846),
  500: Color(0xffFDB846),
  600: Color(0xffFDB846),
  700: Color(0xffFDB846),
  800: Color(0xffFDB846),
  900: Color(0xffFDB846)
});

const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}

const String cookieKey = "local_genie_cookie_key";
const String userNameKey = "local_genie_username_key";

const Map<String, dynamic> orderStatusMap = {
  "Pending": {
    "name": "Pending",
    "shortName": "Pending",
    "status": "Pending",
  },
  "Accepted": {
    "name": "Accepted",
    "shortName": "Accept",
    "status": "Accepted",
  },
  "Completed": {
    "name": "Completed",
    "shortName": "Complete",
    "status": "Completed",
  },
  "OutToDeliver": {
    "name": "Out To Deliver",
    "shortName": "Out To Deliver",
    "status": "OutToDeliver",
  },
  "ReadyToPick": {
    "name": "Ready To Pick",
    "shortName": "Ready To Pick",
    "status": "ReadyToPick",
  },
  "Cancelled": {
    "name": "Cancelled",
    "shortName": "Cancel",
    "status": "Cancelled",
  },
  "InProgress": {
    "name": "In Progress",
    "shortName": "Prepare",
    "status": "InProgress",
  },
  "Rejected": {
    "name": "Rejected",
    "shortName": "Rejected",
    "status": "Rejected",
  },
};
