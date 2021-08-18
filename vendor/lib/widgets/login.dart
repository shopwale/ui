import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/services/catalog.dart';
import 'package:shared/services/notification.dart';
import 'package:shared/services/order.dart';
import 'package:shared/services/provider.dart';
import 'package:vendor/widgets/current_orders.dart';

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
  int mobileNumber;
  String fcmToken;

  LoginState(
    this.providerService,
    this.orderService,
    this.currentOrdersFactory,
    this.catalogService,
    this.notificationService,
  ) {
    FirebaseMessaging.onMessage.listen(print);

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      fcmToken = token;
      print('Push Messaging token: $token');
    });
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
                        final provider = await providerService
                            .getServiceProviderInfo(mobileNumber);

                        if (!provider.tokens.contains(fcmToken)) {
                          notificationService.addProviderFcmToken(
                              serviceProviderId: provider.id, token: fcmToken);
                        }

                        final details = await Future.wait([
                          orderService.getOrders(
                            provider.id,
                            fromDate:
                                DateTime.now().subtract(Duration(days: 3)),
                          ),
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
