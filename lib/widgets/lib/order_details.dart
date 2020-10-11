import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor/models/lib/order.dart';

class OrderDetails extends StatelessWidget {
  final Order order;
  final List<ItemOrder> itemOrders;

  const OrderDetails({
    Key key,
    @required this.itemOrders,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderId}'),
      ),
      floatingActionButton: FlatButton(
        onPressed: () {},
        child: Text('Update Status'),
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Chip(
            label: Text(order.isDelivery ? 'Delivery' : 'Pickup'),
          ),
        ),
        ...itemOrders
            .map(
              (itemOrder) => Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '${itemOrder.quantity} x ${itemOrder.item.name}',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  ),
                ),
              ),
            )
            .toList()
      ]),
    );
  }
}
