import 'dart:math';

import 'package:meta/meta.dart';
import 'package:shared/models/catalog.dart';
import 'package:shared/models/order.dart';
import 'package:shared/services/db.dart';
import 'package:intl/intl.dart';

class OrderService {
  Future<List<Order>> getOrdersByCustomerId(int customerId) async {
    // http://localgenie.in:3000/getOrders?customerId=2
    final dbClient = DbClient('getOrders');
    final orders = await dbClient.get(queryParams: {
      'customerId': customerId.toString(),
    });

    return orders.map<Order>((orderJson) => Order.fromJson(orderJson)).toList();
  }

  // last 1, 2, 3, 5, 10, 15

  Future<List<Order>> getOrders(
    int serviceProviderId, {
    @required DateTime fromDate,
    DateTime toDate,
  }) async {
    final DateFormat formatter = DateFormat('yyyy-M-d');

    // http://localgenie.in:3001/getOrders?serviceProviderId=2&dateRange=custom~2021-02-10:2021-08-10
    final dbClient = DbClient('getOrders', serverPort: 3001);
    final orders = await dbClient.get(queryParams: {
      'serviceProviderId': serviceProviderId.toString(),
      'dateRange': 'custom~${formatter.format(fromDate)}'
          ':${formatter.format(toDate ?? DateTime.now())}',
    });

    return orders.map<Order>((orderJson) => Order.fromJson(orderJson)).toList();
  }

  Future<List<ItemOrder>> getOrderDetails(int orderId) async {
    // http://localgenie.in:3001/getOrderDetails?orderId=13
    final dbClient = DbClient('getOrderDetails', serverPort: 3001);
    final response = await dbClient.get(queryParams: {
      'orderId': orderId.toString(),
    });

    final items = response['items'];
    return items
        .map<ItemOrder>((itemOrderJson) => ItemOrder.fromJson(itemOrderJson))
        .toList();
  }

  Future<OrderStatus> updateOrderStatus(OrderStatus update) async {
    // http://localgenie.in:3001/updateOrderStatus
    // payload: {"orderId":2,"orderStatus":"Pending"}
    final dbClient = DbClient('updateOrderStatus', serverPort: 3001);
    final response = await dbClient.post(body: update.toMap());
    return OrderStatus.fromJson(response);
  }

  Future<OrderStatus> placeOrder(Order order) async {
    final response = await DbClient('order').post(body: order.toMap());
    return OrderStatus.fromJson(response);
  }
}

class FakeOrderService implements OrderService {
  @override
  Future<List<Order>> getOrdersByCustomerId(int _) => Future.value(
        List.generate(
          _rnd.nextInt(100),
          (index) => createFakeOrder(index),
        ),
      );

  @override
  Future<List<Order>> getOrders(
    int serviceProviderId, {
    @required DateTime fromDate,
    DateTime toDate,
  }) =>
      Future.value(
        List.generate(
          _rnd.nextInt(100),
          (index) => createFakeOrder(index),
        ),
      );

  Order createFakeOrder(int orderId) => Order(
        customerId: _rnd.nextInt(10) + 1,
        orderId: orderId,
        orderDate: DateTime.now(),
        orderStatus: OrderStatusEnum.values[_rnd.nextInt(4)],
        isDelivery: _rnd.nextBool(),
        customerName: 'Vimal K',
      );

  @override
  Future<List<ItemOrder>> getOrderDetails(int orderId) => Future.value(
        List.generate(
          _rnd.nextInt(20),
          (index) => createItemOrder(index),
        ),
      );

  ItemOrder createItemOrder(int itemId) => ItemOrder(
        item: CatalogItem(
          name: getRandomString(10),
          id: itemId,
          subCategoryName: getRandomString(10),
          unitOfMeasure: Unit.values[_rnd.nextInt(2)],
        ),
        quantity: _rnd.nextInt(11) + 1,
      );

  @override
  Future<OrderStatus> updateOrderStatus(OrderStatus update) =>
      Future.value(update);

  @override
  Future<OrderStatus> placeOrder(Order order) {
    return Future.value(
        OrderStatus(orderId: 1, status: OrderStatusEnum.accepted));
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
