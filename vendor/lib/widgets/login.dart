import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/provider.dart';
import 'package:shared/services/catalog.dart';
import 'package:shared/services/notification.dart';
import 'package:shared/services/order.dart';
import 'package:shared/services/provider.dart';
import 'package:vendor/widgets/current_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'error_snack_bar.dart';
import 'loading_overlay.dart';

@injectable
class Login extends StatefulWidget {
  const Login();

  @override
  State<Login> createState() => GetIt.instance<LoginState>();
}

@injectable
class LoginState extends State<Login> {
  final ProviderService providerService;
  final OrderService orderService;
  final CatalogService catalogService;
  final CurrentOrdersFactory currentOrdersFactory;
  final NotificationService notificationService;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final Future<SharedPreferences> preferences;
  int mobileNumber;
  String fcmToken;

  LoginState(
    this.providerService,
    this.orderService,
    this.currentOrdersFactory,
    this.catalogService,
    this.notificationService,
  ) : preferences = SharedPreferences.getInstance() {
    FirebaseMessaging.onMessage.listen(print);

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      fcmToken = token;
      print('Push Messaging token: $token');
    });
  }

  @override
  void initState() {
    super.initState();
    preferences.then((prefs) => setState(() {
          mobileNumber = prefs.getInt(mobileNumberPrefsKey);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Get Started')),
        body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  controller: TextEditingController()
                    ..value = TextEditingValue(
                      text: mobileNumber?.toString() ?? '',
                      selection: new TextSelection.collapsed(
                        offset: mobileNumber?.toString()?.length ?? 0 - 1,
                      ),
                    ),
                  decoration:
                      InputDecoration(labelText: "Enter your mobile number"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  onChanged: (value) async {
                    setState(() {
                      mobileNumber = int.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 16.0),
              FlatButton(
                onPressed: mobileNumber?.toString()?.length != 10
                    ? null
                    : () async {
                        showLoadingOverlay(context);

                        Provider provider;
                        List details;
                        bool loggedIn = false;
                        try {
                          provider = await providerService
                              .getServiceProviderInfo(mobileNumber);

                          preferences.then((prefs) {
                            prefs.setInt(mobileNumberPrefsKey, mobileNumber);
                          });

                          if (!provider.tokens.contains(fcmToken)) {
                            notificationService.addProviderFcmToken(
                              serviceProviderId: provider.id,
                              token: fcmToken,
                            );
                          }

                          details = await Future.wait([
                            orderService.getOrders(
                              provider.id,
                              fromDate: DateTime.now().subtract(
                                Duration(days: 3),
                              ),
                            ),
                            catalogService.byProviderId(provider.id),
                          ]);

                          loggedIn = true;
                        } catch (error) {
                          log('$error');
                          showError(
                            context,
                            'Error logging in. '
                            'Please check your number and try again.',
                          );
                        } finally {
                          Navigator.of(context).pop();
                        }

                        if (!loggedIn) return;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => currentOrdersFactory.create(
                              serviceProviderId: provider.id,
                              catalogItems: details[1],
                            ),
                          ),
                        );
                      },
                child: Text('Log In'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ));
  }

  String get mobileNumberPrefsKey => 'mobileNumber';
}
