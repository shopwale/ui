import 'package:flutter/material.dart';
import 'package:shared/models/order.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrderStatus orderStatus;

  const OrderStatusWidget({Key key, this.orderStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Center(
        child: Text(
          'Your order (#${orderStatus.orderId}) has been ${orderStatus.status.asString()}!',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline6.fontSize,
          ),
        ),
      ),
    );
  }
}
