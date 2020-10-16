import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:vendor/common/lib/constants.dart';
import 'package:vendor/models/lib/order.dart';
import 'package:vendor/models/lib/catalog.dart';
import 'package:vendor/services/lib/order.dart';
import 'package:vendor/types/lib/inject.dart';

@provide
class OrderDetailsFactory {
  final Provider<OrderDetailsState> stateProvider;

  OrderDetailsFactory(this.stateProvider);

  OrderDetails create({
    Key key,
    @required List<ItemOrder> itemOrders,
    @required Order order,
  }) =>
      OrderDetails(stateProvider(), itemOrders: itemOrders, order: order);
}

class OrderDetails extends StatefulWidget {
  final Order order;
  final List<ItemOrder> itemOrders;
  final OrderDetailsState orderDetailsState;

  OrderDetails(
    this.orderDetailsState, {
    Key key,
    @required this.itemOrders,
    @required this.order,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => orderDetailsState;
}

@provide
class OrderDetailsState extends State<OrderDetails> {
  final OrderService orderService;

  OrderDetailsState(this.orderService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order by ${widget.order.customerName}'),
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
        children: widget.itemOrders
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
              data: formatter.format(widget.order.orderDate),
            ),
            _buildLabelledData(
              context,
              label: 'Type',
              data: widget.order.isDelivery ? 'Delivery' : 'Pickup',
            ),
            _buildLabelledData(
              context,
              label: 'Status',
              data: capitalize(widget.order.orderStatus.asString()),
            ),
            _buildLabelledData(
              context,
              label: 'Total',
              data: '$rupeeSymbol ${widget.order.totalPrice}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.order.orderStatus == OrderStatusEnum.pending)
                  _buildUpdateStatusButton(context, OrderStatusEnum.accepted),
                if (widget.order.orderStatus == OrderStatusEnum.pending)
                  _buildUpdateStatusButton(context, OrderStatusEnum.rejected),
                if (widget.order.orderStatus == OrderStatusEnum.accepted &&
                    widget.order.isDelivery)
                  _buildUpdateStatusButton(
                      context, OrderStatusEnum.outForDelivery),
                if (widget.order.orderStatus == OrderStatusEnum.accepted &&
                    !widget.order.isDelivery)
                  _buildUpdateStatusButton(context, OrderStatusEnum.completed),
                if (widget.order.orderStatus ==
                        OrderStatusEnum.outForDelivery &&
                    widget.order.isDelivery)
                  _buildUpdateStatusButton(context, OrderStatusEnum.completed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateStatusButton(
    BuildContext context,
    OrderStatusEnum orderStatusEnum,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: FlatButton(
        color: Theme.of(context).accentColor,
        onPressed: () async {
          final updatedOrderStatus = await orderService.updateOrderStatus(
            OrderStatus(
              orderId: widget.order.orderId,
              status: orderStatusEnum,
            ),
          );
          setState(() {
            widget.order.orderStatus = updatedOrderStatus.status;
          });
        },
        child: Text(capitalize(orderStatusEnum.asActionString())),
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
          Text(
            data,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
            ),
          ),
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
