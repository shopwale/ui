import 'package:local_genie_vendor/models/customer_modal.dart';
import 'package:local_genie_vendor/services/app_service.dart';

class Order {
  String orderId;
  double totalPrice;
  String status;
  String orderDate;
  int customerId;
  bool isDeliver;
  String lastStatusUpdated;

  Order({
    required this.status,
    required this.orderId,
    required this.orderDate,
    required this.lastStatusUpdated,
    this.totalPrice = 0,
    this.customerId = 1,
    this.isDeliver = false,
  });

  Order.fromJson(Map<String, dynamic> json)
      : this(
          orderId: json['orderId'].toString(),
          orderDate: getDate(json['orderDate']),
          lastStatusUpdated: json['lastStatusUpdated'],
          status: json['orderStatus'],
          isDeliver: json['isDeliver'],
          totalPrice: double.parse(json['totalPrice'].toString()),
          // savings: double.parse(
          //     (json['total_savings'] ? json['total_savings'] : 0.0).toString()),
        );

  @override
  String toString() {
    return 'Order(orderId: $orderId orderDate: $orderDate isDeliver: $isDeliver totalPrice: $totalPrice status: $status lastStatusUpdated: $lastStatusUpdated)';
  }

  @override
  bool operator ==(covariant Order other) {
    return identical(this, other);
  }

  @override
  int get hashCode => orderId.hashCode ^ orderId.hashCode;
}

class OrderStatus {
  String name;
  String? id;
  String description;
  String statusChangedOn;

  OrderStatus({
    required this.name,
    required this.statusChangedOn,
    this.id = "",
    this.description = "",
  });

  OrderStatus.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'] ?? "",
          id: json['_id'] ?? "",
          statusChangedOn: json['createdAt'] ?? "",
          description: json['description'] ?? "",
        );

  @override
  String toString() {
    return 'OrderStatus(name: $name id: $id statusChangedOn: $statusChangedOn description: $description)';
  }
}

class OrderDetailsI {
  CustomerI customer;
  List<dynamic> items;
  String customerId;
  String orderId;
  String orderDate;
  String orderStatus;
  double totalPrice;
  bool isDeliver;

  OrderDetailsI({
    required this.orderId,
    required this.customerId,
    required this.orderDate,
    required this.orderStatus,
    required this.customer,
    required this.items,
    this.totalPrice = 0.0,
    this.isDeliver = false,
  });

  OrderDetailsI.fromJson(Map<String, dynamic> json)
      : this(
          orderId: json['orderId'].toString(),
          customerId: json['customerId'].toString(),
          orderDate: json['orderDate'] ?? DateTime.now().toString(),
          orderStatus: json['orderStatus'],
          items: ((json['items'] ?? [])
              .map((item) => OrderItemI.fromJson(item))).toList(),
          totalPrice: double.parse((json['totalPrice'] ?? 0).toString()),
          customer: CustomerI.fromJson(json['customerDetails']),
          isDeliver: bool.parse((json['isDeliver'] ?? false).toString()),
        );

  OrderDetailsI copyWithStatus(String status) => OrderDetailsI(
      customer: customer,
      orderId: orderId,
      orderDate: orderDate,
      items: items,
      customerId: customerId,
      orderStatus: status,
      totalPrice: totalPrice,
      isDeliver: isDeliver);

  @override
  String toString() {
    return 'OrderDetailsI(orderId: $orderId, orderDate: $orderDate, orderStatus: $orderStatus, items: $items, totalPrice: $totalPrice, isDeliver: $isDeliver, customer: $customer)';
  }
}

class OrderItemI {
  double subTotalPrice;
  int quantity;
  String unitOfMeasure;
  String itemId;
  String itemName;
  String itemIconURL;

  OrderItemI(
      {required this.subTotalPrice,
      required this.quantity,
      required this.unitOfMeasure,
      required this.itemName,
      required this.itemId,
      this.itemIconURL = ""});

  OrderItemI.fromJson(Map<String, dynamic> json)
      : this(
          subTotalPrice: double.parse((json['subTotalPrice'] ?? 0).toString()),
          quantity: json['quantity'],
          unitOfMeasure: json['unitOfMeasure'].toString(),
          itemId: json['itemId'].toString(),
          itemName: json['itemName'],
          itemIconURL: json['itemIconURL'] ?? "",
        );

  @override
  String toString() {
    return "OrderItemI(subTotalPrice: $subTotalPrice, quantity: $quantity, unitOfMeasure: $unitOfMeasure itemName: $itemName)";
  }
}

class OrderDetailsArgumentsI {
  final String orderId;

  OrderDetailsArgumentsI({this.orderId = ""});

  OrderDetailsArgumentsI.fromJson(Map<String, dynamic> json)
      : this(orderId: (json['orderId'] ?? "").toString());
}
