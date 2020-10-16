import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inject/inject.dart';
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
  final CurrentOrdersFactory currentOrdersFactory;
  int mobileNumber;

  LoginState(
    this.providerService,
    this.orderService,
    this.currentOrdersFactory,
  );

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
                onPressed:
                    // mobileNumber?.toString()?.length != 10
                    //     ? null
                    //     :

                    () async {
                  final provider = await providerService
                      .getServiceProviderInfo(mobileNumber);

                  print(provider.name);

                  final orders = await orderService.getOrders(provider.id);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => currentOrdersFactory.create(
                        orders: orders,
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
