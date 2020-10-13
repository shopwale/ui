import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:vendor/common/lib/constants.dart';
import 'package:vendor/models/lib/order.dart';
import 'package:vendor/models/lib/catalog.dart';

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
        title: Text('Order by ${order.customerName}'),
      ),
      floatingActionButton: FlatButton(
        onPressed: () {},
        child: Text('Update Status'),
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderMetadataCard(context),
            _buildRowSpacer(),
            _buildLabel(context, 'Items'),
            Flexible(child: _buildItemsList()),
          ],
        ),
      ),
    );
  }

  Padding _buildItemsList() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        key: Key('ItemOrdersList'),
        children: itemOrders
            .map(
              (itemOrder) => Padding(
                key: Key(itemOrder.item.id.toString()),
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(itemOrder.quantity.toString()),
                    ),
                    SizedBox(
                      width: 20,
                      child: Text(itemOrder.item.unitOfMeasure.asString()),
                    ),
                    SizedBox(width: 32.0),
                    Text(
                        '${itemOrder.item.subCategoryName} - ${itemOrder.item.name}'),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Card _buildOrderMetadataCard(BuildContext context) {
    final DateFormat formatter = DateFormat('hh:mm, dd MMM');

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLabelledData(
              context,
              label: 'Date',
              data: formatter.format(order.orderDate),
            ),
            _buildLabelledData(
              context,
              label: 'Type',
              data: order.isDelivery ? 'Delivery' : 'Pickup',
            ),
            _buildLabelledData(
              context,
              label: 'Status',
              data: capitalize(order.orderStatus.asString()),
            ),
            _buildLabelledData(
              context,
              label: 'Total',
              data: '$rupeeSymbol ${order.totalPrice}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelledData(
    BuildContext context, {
    @required String label,
    @required String data,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildLabel(context, label),
          SizedBox(width: 32.0),
          Text(data),
        ],
      ),
    );
  }

  SizedBox _buildLabel(BuildContext context, String data) {
    final labelTextStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.headline6.fontSize,
    );

    return SizedBox(
      width: 60.0,
      child: Text(data, style: labelTextStyle),
    );
  }

  Widget _buildRowSpacer() => SizedBox(height: 16.0);
}
