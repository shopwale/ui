import 'package:meta/meta.dart';
import 'package:strings/strings.dart';
import 'catalog.dart';

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
          isDelivery: json['isDeliver'],
          totalPrice: json['totalPrice'].toDouble(),
          customerName: json['customerName'],
        );
}

enum OrderStatusEnum {
  pending,
  accepted,
  rejected,
  completed, // delivered or picked up.
  outToDeliver,
  readyToPick,
}

extension OrderStatusEnumExtension on OrderStatusEnum {
  String asString() {
    return describeEnum(this)
        .replaceAllMapped(RegExp("([A-Z])"), (m) => ' ${m[0].toLowerCase()}');
  }

  String asActionString() {
    switch (this) {
      case OrderStatusEnum.pending:
        return 'Pending';
      case OrderStatusEnum.accepted:
        return 'Accept';
      case OrderStatusEnum.rejected:
        return 'Reject';
      case OrderStatusEnum.completed:
        return 'Complete';
      case OrderStatusEnum.outToDeliver:
        return 'Out to deliver';
      case OrderStatusEnum.readyToPick:
        return 'Ready to pick';
      default:
        throw 'Invalid Status';
    }
  }
}

OrderStatusEnum toOrderStatusEnum(String value) {
  return OrderStatusEnum.values.firstWhere((e) =>
      e.toString().toLowerCase() == 'orderstatusenum.${value.toLowerCase()}');
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
          item: CatalogItem(id: json['itemId']),
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
        'orderStatus': capitalize(describeEnum(status)),
      };
}
