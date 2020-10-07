import 'package:flutter/material.dart';
import 'package:vendor/models/lib/order.dart';
import 'package:vendor/models/lib/catalog.dart';

class CurrentOrders extends StatelessWidget {
  final List<Order> orders;

  const CurrentOrders({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView(
        children: orders
            .map(
              (o) => ExpansionTile(
                key: Key(o.orderId.toString()),
                title: Text('Order #${o.orderId}'),
                children: o.itemOrders
                    .map(
                      (itemOrder) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                                '${itemOrder.quantity} ${itemOrder.item.unitOfMeasure.asString()} ${itemOrder.item.name}')
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
