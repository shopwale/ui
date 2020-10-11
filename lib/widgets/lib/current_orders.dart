import 'package:flutter/material.dart';
import 'package:vendor/common/lib/constants.dart';
import 'package:vendor/models/lib/order.dart';
import 'package:vendor/services/lib/order.dart';
import 'package:vendor/widgets/lib/order_details.dart';

class CurrentOrders extends StatelessWidget {
  final List<Order> orders;
  final OrderService orderService;

  CurrentOrders(this.orderService, {Key key, @required this.orders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView(
        children: orders
            .map(
              (o) => GestureDetector(
                onTap: () async {
                  final itemOrders =
                      await orderService.getOrderDetails(o.orderId);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetails(
                        order: o,
                        itemOrders: itemOrders,
                      ),
                    ),
                  );
                },
                child: Card(
                  key: Key(o.orderId.toString()),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          o.isDelivery
                              ? Icons.delivery_dining
                              : Icons.shopping_bag,
                          color: o.isDelivery
                              ? Theme.of(context).accentColor
                              : null,
                        ),
                        title: Text('Order #${o.orderId}'),
                        trailing: Text('$rupeeSymbol ${o.totalPrice}'),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// o.itemOrders
//                     .map(
//                       (itemOrder) => Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 8.0,
//                           horizontal: 16.0,
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                                 '${itemOrder.quantity} ${itemOrder.item.unitOfMeasure.asString()} ${itemOrder.item.name}')
//                           ],
//                         ),
//                       ),
//                     )
//                     .toList(),
