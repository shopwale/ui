import 'dart:async';

import 'package:flutter/material.dart';

class CountDownTime extends StatefulWidget {
  String date;
  String text;
  TextStyle style;
  CountDownTime(
      {Key? key,
      required this.date,
      this.text = "",
      this.style = const TextStyle(fontSize: 11)})
      : super(key: key);

  @override
  _CountDownTimeState createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {
  String strDigits(int n) => n.toString().padLeft(2, '0');
  Timer? timer;

  int totalSeconds = 0;

  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      startTimer();
    }
  }

  @override
  void dispose() {
    resetTimer();
    super.dispose();
  }

  resetTimer() {
    timer?.cancel();
  }

  resetTime() {
    setState(() {
      totalSeconds = (DateTime.parse(widget.date).millisecondsSinceEpoch -
              DateTime.now().millisecondsSinceEpoch) ~/
          Duration.millisecondsPerSecond;
      days = 0;
      hours = 0;
      minutes = 0;
      seconds = 0;
    });
  }

  startTimer() {
    resetTimer();
    resetTime();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      seconds = ((DateTime.parse(widget.date).toLocal().millisecondsSinceEpoch -
                  (DateTime.now().toLocal()).millisecondsSinceEpoch) ~/
              Duration.millisecondsPerSecond)
          .floor();
      minutes = (seconds / 60).floor();
      hours = (minutes / 60).floor();
      days = (hours / 24).floor();

      hours = hours - (days * 24);
      minutes = minutes - (days * 24 * 60) - (hours * 60);
      seconds =
          seconds - (days * 24 * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
      setState(() {
        days = days;
        hours = hours;
        minutes = minutes;
        seconds = seconds;
      });
      // print(
      //     "${strDigits(hours)}: ${strDigits(minutes)}: ${strDigits(seconds)}");

      if (seconds < 0) {
        resetTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text}${strDigits(days)}: ${strDigits(hours)}: ${strDigits(minutes)}: ${strDigits(seconds)}',
      style: widget.style,
    );
  }
}
