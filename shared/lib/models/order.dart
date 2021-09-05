import 'package:meta/meta.dart';
import 'package:strings/strings.dart';
import 'package:shared/models/catalog.dart';

class Order {
  /// Map from item id to item orders.
  final Map<CatalogItem, ItemOrder> itemOrders = {};
  final int serviceProviderId;
  final int orderId;
  final DateTime orderDate;
  OrderStatusEnum orderStatus;
  bool isDelivery;
  int customerId;
  String customerName;
  double totalPrice;

  Order({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.customerName,
    this.customerId,
    this.isDelivery = true,
    this.serviceProviderId,
    this.totalPrice,
  });

  Order.fromJson(Map<String, dynamic> json)
      : this(
          customerId: json['customerId'],
          orderId: json['orderId'],
          orderDate: DateTime.parse(json['orderDate']),
          orderStatus: toOrderStatusEnum(json['orderStatus']),
          isDelivery: json['isDeliver'],
          customerName: json['customerName'],
          totalPrice: (json['totalPrice'] as num).toDouble(),
        );

  ItemOrder addItemOrder(ItemOrder newOrder) {
    if (itemOrders[newOrder.item] == null) {
      itemOrders[newOrder.item] = newOrder;
      return newOrder;
    }

    final existingItemOrder = itemOrders[newOrder.item];
    final updatedItemOrder = ItemOrder(
      item: newOrder.item,
      quantity: existingItemOrder.quantity + newOrder.quantity,
    );

    return updatedItemOrder;
  }

  ItemOrder updateItemOrder(ItemOrder order) {
    itemOrders[order.item] = order;
    return order;
  }

  Map<String, dynamic> toMap() => {
        'serviceProviderId': serviceProviderId,
        'customerId': customerId,
        'items': itemOrders.values
            .where((i) => i.quantity != 0)
            .map((i) => i.toMap())
            .toList(),
        'totalPrice': totalPrice,
        'isDeliver': isDelivery,
      };
}

enum OrderStatusEnum {
  pending,
  accepted,
  rejected, // by service provider.
  cancelled, // by customer.
  inProgress,
  completed, // delivered or picked up.
  outToDeliver,
  readyToPick,
}

extension OrderStatusEnumExtension on OrderStatusEnum {
  String asShortString() {
    return describeEnum(this)
        .replaceAllMapped(RegExp("([A-Z])"), (m) => ' ${m[0].toLowerCase()}');
  }

  String asString() {
    switch (this) {
      case OrderStatusEnum.cancelled:
        return 'Cancelled by customer';
      case OrderStatusEnum.rejected:
        return 'Cancelled by us';
      default:
        return asShortString();
    }
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
      case OrderStatusEnum.cancelled:
        throw 'Invalid status';
      case OrderStatusEnum.inProgress:
        return 'In progress';
    }

    return null;
  }
}

OrderStatusEnum toOrderStatusEnum(String value) {
  return OrderStatusEnum.values.firstWhere(
    (e) =>
        e.toString().toLowerCase() == 'orderstatusenum.${value.toLowerCase()}',
    orElse: () => OrderStatusEnum.pending,
  );
}

class ItemOrder {
  int _quantity;
  final CatalogItem item;

  ItemOrder({
    @required this.item,
    int quantity,
  }) : _quantity = quantity ?? 0;

  int get quantity => _quantity;

  void decrement() {
    _quantity--;
  }

  void increment() {
    _quantity++;
  }

  double get subTotalPrice => _quantity * item.price;

  ItemOrder.fromJson(Map<String, dynamic> json)
      : this(
          quantity: json['quantity'],
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

String describeEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
