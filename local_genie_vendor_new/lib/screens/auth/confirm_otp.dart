import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/http_modal.dart';
import 'package:local_genie_vendor/screens/auth/login_sreen.dart';
import 'package:local_genie_vendor/widgets/auth_sub_title.dart';
import 'package:local_genie_vendor/widgets/auth_title.dart';
import 'package:local_genie_vendor/widgets/filled_button.dart';
import 'package:local_genie_vendor/widgets/snackbar.dart';

class ConfirmOtpPage extends StatefulWidget {
  const ConfirmOtpPage({
    super.key,
    required this.username,
  });

  final String username;
  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
  TextEditingController otp1 = TextEditingController(text: '');
  TextEditingController otp2 = TextEditingController(text: '');
  TextEditingController otp3 = TextEditingController(text: '');
  TextEditingController otp4 = TextEditingController(text: '');
  TextEditingController otp5 = TextEditingController(text: '');
  Timer? timer;
  bool _showLoader = false;
  int seconds = 120;

  Widget otpBox(TextEditingController otpController) {
    return SizedBox(
      height: 48,
      width: 48,
      child: TextField(
        controller: otpController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: const TextStyle(color: Colors.white),
            floatingLabelStyle: const TextStyle(color: Colors.green),
            counterText: ""
            // hintStyle: TextStyle(color: Colors.white),
            ),
        style: const TextStyle(fontSize: 16.0, color: Colors.green),
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        maxLength: 1,
      ),
    );
  }

  void initState() {
    super.initState();

    if (mounted) {
      startTimer();
    }
  }

  @override
  void dispose() {
    resetTimer(reset: false);
    super.dispose();
  }

  startTimer() {
    resetTimer();
    resetSeconds();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds = seconds - 1;
      });

      if (seconds < 0) {
        resetTimer();
      }
    });
  }

  resetSeconds({second = 120}) {
    setState(() {
      seconds = second;
    });
  }

  resetTimer({reset = true}) {
    timer?.cancel();
    if (reset) resetSeconds(second: -1);
  }

  @override
  Widget build(BuildContext context) {
    showLoader({show = false}) async {
      setState(() {
        _showLoader = show;
      });
    }

    Widget title = TitleWidget('Confirm your OTP');

    Widget subTitle = SubTitleWidget('Please wait, we are confirming your OTP');

    Widget verifyButton = CustomFilledButton(
      context,
      color: Colors.green,
      text: seconds > 0 ? "Verify" : "Resend OTP",
      onPressed: () async {
        showLoader(show: true);
        if (seconds > 0) {
          try {
            if (otp1.text == "" ||
                otp2.text == "" ||
                otp3.text == "" ||
                otp4.text == "" ||
                otp5.text == "") {
              GlobalSnackBar.show(context, "Please enter your OTP");
              showLoader(show: false);
              return;
            }
            // await verifyOtp(
            //   widget.username,
            //   otp1.text + otp2.text + otp3.text + otp4.text + otp5.text,
            // );

            resetTimer();
            showLoader(show: false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          } catch (e) {
            var obj = e as ErrorI;
            GlobalSnackBar.show(context, obj.message);
            showLoader(show: false);
          }
          // });
        } else {
          // resetTimer();
          try {
            // await sendOtp(widget.username);
            startTimer();
            GlobalSnackBar.show(
              context,
              "Otp sent to your ${widget.username}!",
            );
            showLoader(show: false);
          } catch (e) {
            GlobalSnackBar.show(
                context, "Otp could not sent to your ${widget.username}!");
            showLoader(show: false);
          }
        }
      },
      showLoader: _showLoader,
    );

    Widget otpCode = Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          otpBox(otp1),
          otpBox(otp2),
          otpBox(otp3),
          otpBox(otp4),
          otpBox(otp5)
        ],
      ),
    );

    Widget resendText = Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Resend again after ",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                seconds.toString(),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
            const Text(
              "Seconds",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ));

    return Scaffold(
        backgroundColor: yellow,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                title,
                subTitle,
                otpCode,
                verifyButton,
                if (seconds > 0) resendText,
              ],
            ),
          ),
        ));
  }
}
