import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:local/common/lib/constants.dart';
import 'package:shared/models/order.dart';
import 'package:shared/models/catalog.dart';
import 'package:shared/services/customer.dart';
import 'package:shared/services/order.dart';
import 'package:local/widgets/lib/order_confirmation_dialog.dart';

@injectable
class CheckoutFactory {
  final OrderService orderService;
  final CustomerService customerService;
  final OrderConfirmationDialogFactory orderConfirmationDialogFactory;

  CheckoutFactory(this.orderService, this.customerService,
      this.orderConfirmationDialogFactory);

  Checkout create(Order order) => Checkout(
        orderService,
        customerService,
        order: order,
        orderConfirmationDialogFactory: orderConfirmationDialogFactory,
      );
}

class Checkout extends StatelessWidget {
  final Order order;
  final OrderService orderService;
  final CustomerService customerService;
  final OrderConfirmationDialogFactory orderConfirmationDialogFactory;

  Checkout(
    this.orderService,
    this.customerService, {
    Key key,
    @required this.order,
    @required this.orderConfirmationDialogFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Checkout')),
        floatingActionButton: Align(
          alignment: Alignment(1, 0.85),
          child: _buildOrderButton(context),
        ),
        bottomSheet: Container(
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              Text('$rupeeSymbol ${order.totalPrice}'),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: order.itemOrders.values
                  .where((itemOrder) => itemOrder.quantity != 0)
                  .map((itemOrder) {
                final item = itemOrder.item;

                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.subCategoryName} - ${item.name}',
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline6.fontSize,
                          ),
                        ),
                        flex: 2,
                      ),
                      Spacer(),
                      Expanded(
                        child: Text(
                          '${itemOrder.quantity.toString()} ${item.unitOfMeasure.asString()}',
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline6.fontSize,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$rupeeSymbol ${itemOrder.subTotalPrice}',
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline6.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }

  FlatButton _buildOrderButton(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        print('Order button pressed.');
        print(order.toMap());

        // show the dialog
        await _showOrderConfirmationDialog(context);
      },
      child: Text('Order'),
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
    );
  }

  Future _showOrderConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return orderConfirmationDialogFactory.create(order);
      },
    );
  }
}
