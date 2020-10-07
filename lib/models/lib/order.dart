import 'package:flutter/foundation.dart';
import 'package:vendor/models/lib/catalog.dart';

class Order {
  final List<ItemOrder> itemOrders;
  final int serviceProviderId;
  final int orderId;
  int customerId;

  Order({
    this.orderId,
    this.serviceProviderId,
    this.customerId,
    this.itemOrders,
  });
}

class ItemOrder {
  int _quantity;
  CatalogItem item;

  ItemOrder({
    @required this.item,
    int quantity,
  }) : _quantity = quantity ?? 0;

  int get quantity => _quantity;

  double get subTotalPrice => _quantity * item.price;

  Map<String, dynamic> toMap() => {
        'itemId': item.id,
        'quantity': quantity,
        'subTotalPrice': subTotalPrice,
      };
}

class OrderStatus {
  final int orderId;
  final String status;

  OrderStatus({@required this.orderId, @required this.status});

  static OrderStatus fromJson(Map<String, dynamic> json) => OrderStatus(
        orderId: json['orderId'],
        status: json['orderStatus'],
      );
}
