import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:vendor/common/constants.dart';
import 'package:shared/models/customer.dart';
import 'package:shared/models/order.dart';
import 'package:shared/models/catalog.dart';
import 'package:shared/services/order.dart';
import 'package:vendor/widgets/loading_overlay.dart';

@injectable
class OrderDetailsFactory {
  const OrderDetailsFactory();

  OrderDetails create({
    Key? key,
    required List<ItemOrder> itemOrders,
    required Order order,
    required Customer customer,
    required List<CatalogItem> catalogItems,
  }) =>
      OrderDetails(
        GetIt.instance<OrderDetailsState>(),
        itemOrders: itemOrders,
        order: order,
        customer: customer,
        catalogItems: catalogItems,
      );
}

class OrderDetails extends StatefulWidget {
  final Order order;
  final List<ItemOrder> itemOrders;
  final Customer customer;
  final List<CatalogItem> catalogItems;
  final OrderDetailsState orderDetailsState;

  OrderDetails(
    this.orderDetailsState, {
    Key? key,
    required this.itemOrders,
    required this.order,
    required this.customer,
    required this.catalogItems,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => orderDetailsState;
}

@injectable
class OrderDetailsState extends State<OrderDetails> {
  final OrderService orderService;

  // For items whose price is unknown, we set them to zero. We show total price
  // only if all items have non-zero price.
  bool get shouldShowTotalPrice =>
      widget.itemOrders.every((itemOrder) => itemOrder.item.price != 0.0);

  OrderDetailsState(this.orderService);

  @override
  Widget build(BuildContext context) {
    log('${widget.itemOrders}');
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
        children: widget.itemOrders.map((itemOrder) {
          final catalogItem = widget.catalogItems.firstWhere(
            (element) => element.id == itemOrder.item.id,
            orElse: () {
              log('Could not find ${itemOrder.item} in catalog by id.' +
                  ' Returning default.');
              return CatalogItem(
                id: 1,
                name: 'Unknown',
                subCategoryName: 'Unknown',
              );
            },
          );

          return Padding(
            key: Key(itemOrder.item.id.toString()),
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (catalogItem.iconUrl != null)
                  Image.network(catalogItem.iconUrl.toString(), width: 40),
                SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(itemOrder.quantity.toString()),
                ),
                SizedBox(
                  width: 20,
                  child: Text(catalogItem.unitOfMeasure.asString()),
                ),
                SizedBox(width: 32.0),
                Text(
                  '${catalogItem.subCategoryName} - ${catalogItem.name}',
                  softWrap: true,
                ),
              ],
            ),
          );
        }).toList(),
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
              label: 'Order #',
              data: widget.order.orderId.toString(),
            ),
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
              label: 'Address',
              data: '${widget.customer.address} ${widget.customer.pinCode}',
            ),
            _buildLabelledData(
              context,
              label: 'Status',
              data: capitalize(widget.order.orderStatus.asString()),
            ),
            if (shouldShowTotalPrice)
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
                if (widget.order.orderStatus == OrderStatusEnum.accepted)
                  _buildUpdateStatusButton(
                    context,
                    widget.order.isDelivery
                        ? OrderStatusEnum.outToDeliver
                        : OrderStatusEnum.readyToPick,
                  ),
                if (widget.order.orderStatus == OrderStatusEnum.outToDeliver ||
                    widget.order.orderStatus == OrderStatusEnum.readyToPick)
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
        color: Theme.of(context).colorScheme.secondary,
        onPressed: () async {
          showLoadingOverlay(context);
          try {
            final updatedOrderStatus = await orderService.updateOrderStatus(
              OrderStatus(
                orderId: widget.order.orderId,
                status: orderStatusEnum,
              ),
            );
            setState(() {
              widget.order.orderStatus = updatedOrderStatus.status;
            });
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(minutes: 1),
                content: Text('$error', softWrap: true),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {},
                ),
              ),
            );
          } finally {
            Navigator.of(context).pop();
          }
        },
        child: Text(
          capitalize(orderStatusEnum.asActionString() ?? ""),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLabelledData(
    BuildContext context, {
    required String label,
    required String data,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildLabel(context, label),
          SizedBox(width: 16.0),
          Flexible(
            child: Text(
              data,
              softWrap: true,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildLabel(BuildContext context, String data) {
    final labelTextStyle = TextStyle(
      color: Theme.of(context).textTheme.headline6?.color?.withOpacity(0.7),
      fontSize: Theme.of(context).textTheme.headline6?.fontSize,
    );

    return SizedBox(
      width: 80.0,
      child: Text(data, style: labelTextStyle),
    );
  }

  Widget _buildRowSpacer() => SizedBox(height: 16.0);
}
