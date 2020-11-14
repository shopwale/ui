import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inject/inject.dart';
import 'package:vendor/services/lib/catalog.dart';
import 'package:vendor/services/lib/notification.dart';
import 'package:vendor/services/lib/order.dart';
import 'package:vendor/services/lib/provider.dart';
import 'package:vendor/types/lib/inject.dart';
import 'package:vendor/widgets/lib/current_orders.dart';

@provide
class Login extends StatefulWidget {
  final Provider<LoginState> stateProvider;

  const Login(this.stateProvider);

  @override
  State<StatefulWidget> createState() => stateProvider();
}

@provide
class LoginState extends State<Login> {
  final ProviderService providerService;
  final OrderService orderService;
  final CatalogService catalogService;
  final CurrentOrdersFactory currentOrdersFactory;
  final NotificationService notificationService;
  final _firebaseMessaging = FirebaseMessaging();
  int mobileNumber;
  String fcmToken;

  LoginState(
    this.providerService,
    this.orderService,
    this.currentOrdersFactory,
    this.catalogService,
    this.notificationService,
  );

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      fcmToken = token;
      print('Push Messaging token: $token');
    });

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
                  decoration:
                      InputDecoration(labelText: "Enter your phone number"),
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
                        final provider = await providerService
                            .getServiceProviderInfo(mobileNumber);

                        if (!provider.tokens.contains(fcmToken)) {
                          notificationService.addProviderFcmToken(
                              serviceProviderId: provider.id, token: fcmToken);
                        }

                        final details = await Future.wait([
                          orderService.getOrders(provider.id),
                          catalogService.byProviderId(provider.id),
                        ]);

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
}
