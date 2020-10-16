import 'package:flutter/foundation.dart';
import 'package:vendor/models/lib/catalog.dart';

class Order {
  final int orderId;
  final int customerId;
  final DateTime orderDate;
  final double totalPrice;
  OrderStatusEnum orderStatus;
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
          orderStatus: toOrderStatusEnum(json['orderStatus']),
          isDelivery: json['isDeliver'] == "true",
          totalPrice: json['totalPrice'].toDouble(),
          customerName: json['customerName'],
        );
}

enum OrderStatusEnum {
  pending,
  accepted,
  rejected,
  completed, // delivered or picked up.
  outForDelivery,
}

extension OrderStatusEnumExtension on OrderStatusEnum {
  String asString() {
    return describeEnum(this)
        .replaceAllMapped("([A-Z])", (m) => ' ${m[0].toLowerCase()}');
  }

  String asActionString() {
    switch (this) {
      case OrderStatusEnum.pending:
        return 'Pending';
        break;
      case OrderStatusEnum.accepted:
        return 'Accept';
        break;
      case OrderStatusEnum.rejected:
        return 'Reject';
        break;
      case OrderStatusEnum.completed:
        return 'Complete';
        break;
      case OrderStatusEnum.outForDelivery:
        return 'Out for Delivery';
        break;
    }
  }
}

OrderStatusEnum toOrderStatusEnum(String value) {
  return OrderStatusEnum.values.firstWhere(
      (e) => e.toString() == 'OrderStatusEnum.${value.toLowerCase()}');
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

  ItemOrder.fromJson(Map<String, dynamic> json)
      : this(
          quantity: json['quantity'],
          subTotalPrice: json[''],
          item: CatalogItem(name: 'XYZ', id: json['itemId']),
        );

  Map<String, dynamic> toMap() => {
        'itemId': item.id,
        'quantity': quantity,
        'subTotalPrice': subTotalPrice,
      };
}

class OrderStatus {
  final int orderId;
  final OrderStatusEnum status;

  OrderStatus({@required this.orderId, @required this.status});

  static OrderStatus fromJson(Map<String, dynamic> json) => OrderStatus(
        orderId: json['orderId'],
        status: toOrderStatusEnum(json['orderStatus']),
      );

  Map<String, dynamic> toMap() => {
        'orderId': orderId,
        'orderStatus': status.asString(),
      };
}
