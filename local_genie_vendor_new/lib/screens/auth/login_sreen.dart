// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/models/http_modal.dart';
import 'package:local_genie_vendor/screens/auth/confirm_otp.dart';
import 'package:local_genie_vendor/widgets/auth_sub_title.dart';
import 'package:local_genie_vendor/widgets/auth_title.dart';
import 'package:local_genie_vendor/widgets/filled_button.dart';
import 'package:local_genie_vendor/widgets/input.dart';
import 'package:local_genie_vendor/widgets/snackbar.dart';

import '../../app_properties.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  TextEditingController username = TextEditingController(
    text: '',
  );

  String _errorUserName = "";
  bool _showLoader = false;

  String _getErrorText(TextEditingController controller, String label) {
    return controller.text == "" ? "Enter $label" : "";
  }

  @override
  Widget build(BuildContext context) {
    showLoader({show = false}) async {
      setState(
        () {
          _showLoader = show;
        },
      );
    }

    Widget title = TitleWidget('Welcome Back,');
    Widget subTitle = SubTitleWidget('Login to your account');

    Widget loginButton(WidgetRef ref) {
      return CustomFilledButton(
        context,
        text: "Send OTP",
        color: Colors.green,
        onPressed: () async {
          setState(
            () {
              // _errorUserName = UserNameValidate(username);
            },
          );

          if (_errorUserName != "") return;
          showLoader(show: true);
          try {
            // var user = await login(username.text);

            showLoader(show: false);
            // ref.read(cartStateProvider.notifier).getCarts();
            // ref.read(ordersStateProvider.notifier).getOrders();
            // ref.read(favouriteStateProvider.notifier).getFavourites();

            // try {
            //   await addFcmToken(await FirebaseMessagingService.getToken());
            // } catch (e) {}

            GlobalSnackBar.show(context, "Welcome Back!");

            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ConfirmOtpPage(username: username.text)));
          } catch (e) {
            print(e);
            print(e.runtimeType);
            print(e.toString());
            showLoader(show: false);
            ErrorI obj = e as ErrorI;
            // var obj = ErrorI.fromJson(jsonDecode(e.toString()));
            setState(
              () {
                _errorUserName =
                    obj.message.contains("registered") ? obj.message : "";
              },
            );
          }
        },
        showLoader: _showLoader,
      );
    }

    Widget loginForm = Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 40, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Input(
            controller: username,
            icon: Icons.person,
            hint: 'Mobile',
            label: 'Mobile',
            errorText: _errorUserName,
          ),
          const SizedBox(height: 40),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return loginButton(ref);
            },
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: yellow,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              title,
              subTitle,
              loginForm,
            ],
          ),
        ),
      ),
    );
  }
}
