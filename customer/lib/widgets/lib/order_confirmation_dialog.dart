import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/lib/order.dart';
import 'package:shared/services/lib/customer.dart';
import 'package:shared/services/lib/notification.dart';
import 'package:shared/services/lib/order.dart';
import 'package:local/types/lib/inject.dart';

import 'order_status.dart';

@injectable
class OrderConfirmationDialogFactory {
  final Provider<OrderConfirmationDialogState> stateProvider;

  OrderConfirmationDialogFactory(this.stateProvider);

  OrderConfirmationDialog create(Order order) => OrderConfirmationDialog(
        order: order,
        orderConfirmationDialogState: stateProvider(),
      );
}

class OrderConfirmationDialog extends StatefulWidget {
  const OrderConfirmationDialog({
    Key key,
    @required this.order,
    @required this.orderConfirmationDialogState,
  }) : super(key: key);

  final Order order;
  final OrderConfirmationDialogState orderConfirmationDialogState;

  @override
  State<StatefulWidget> createState() => orderConfirmationDialogState;
}

@injectable
class OrderConfirmationDialogState extends State<OrderConfirmationDialog> {
  final CustomerService customerService;
  final OrderService orderService;
  final NotificationService notificationService;
  final _firebaseMessaging = FirebaseMessaging();
  int customerMobileNumber;
  String fcmToken;

  OrderConfirmationDialogState(
    this.customerService,
    this.orderService,
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
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      fcmToken = token;
      print('Push Messaging token: $token');
    });
    return AlertDialog(
      title: Text("Confirm Order"),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  label: Text('Pickup'),
                  selected: !widget.order.isDelivery,
                  onSelected: (selected) {
                    setState(() {
                      widget.order.isDelivery = !selected;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                ChoiceChip(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  label: Text('Delivery'),
                  selected: widget.order.isDelivery,
                  onSelected: (selected) {
                    setState(() {
                      widget.order.isDelivery = selected;
                    });
                  },
                )
              ],
            ),
            SizedBox(width: 16.0),
            TextField(
              decoration: InputDecoration(labelText: "Enter your phone number"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (value) async {
                if (value.length != 10) {
                  return;
                }

                customerMobileNumber = int.parse(value);
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () async {
            await _updateCustomerInfo(customerMobileNumber);
            await _placeOrder(context);
          },
          child: Text('Confirm'),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Future _updateCustomerInfo(int mobileNumber) async {
    final customer =
        await customerService.getCustomerByMobileNumber(mobileNumber);
    if (!customer.tokens.contains(fcmToken)) {
      notificationService.addCustomerFcmToken(
          customerId: customer.id, token: fcmToken);
    }

    widget.order.customerId = customer.id;
  }

  Future _placeOrder(BuildContext context) async {
    final orderStatus = await orderService.placeOrder(widget.order);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderStatusWidget(orderStatus: orderStatus),
      ),
    );
  }
}
