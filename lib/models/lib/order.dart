import 'package:flutter/foundation.dart';
import 'package:vendor/models/lib/catalog.dart';

class Order {
  final int orderId;
  final int customerId;
  final DateTime orderDate;
  final double totalPrice;
  final OrderStatus orderStatus;
  final bool isDelivery;
  final String customerName;

  Order({
    @required this.orderId,
    @required this.customerId,
    @required this.orderDate,
    @required this.totalPrice,
    @required this.orderStatus,
    @required this.isDelivery,
    @required this.customerName,
  });

  Order.fromJson(Map<String, dynamic> json)
      : this(
          customerId: json['customerId'],
          orderId: json['orderId'],
          orderDate: DateTime.parse(json['orderDate']),
          orderStatus: json['orderStatus'],
          isDelivery: json['isDeliver'] == "true",
          totalPrice: json['totalPrice'],
          customerName: json['customerName'],
        );
}

enum OrderStatus {
  pending,
  accepted,
  rejected,
  completed, // delivered or picked up.
  outForDelivery,
}

extension OrderStatusExtension on OrderStatus {
  String asString() {
    return describeEnum(this)
        .replaceAllMapped("([A-Z])", (m) => ' ${m[0].toLowerCase()}');
  }

  OrderStatus asOrderStatus(String value) {
    return OrderStatus.values
        .firstWhere((e) => e.toString() == 'Unit.${value.toLowerCase()}');
  }
}

class ItemOrder {
  final int quantity;
  final CatalogItem item;
  final double subTotalPrice;

  ItemOrder({
    @required this.item,
    @required this.quantity,
    @required this.subTotalPrice,
  });

  Map<String, dynamic> toMap() => {
        'itemId': item.id,
        'quantity': quantity,
        'subTotalPrice': subTotalPrice,
      };
}
