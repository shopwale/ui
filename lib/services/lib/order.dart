import 'dart:math';

import 'package:shared/models/lib/catalog.dart';
import 'package:shared/models/lib/order.dart';
import 'package:shared/services/lib/db.dart';

class OrderService {
  Future<List<Order>> getOrders(int serviceProviderId) async {
    // http://localshopwala.com:3001/getOrders?serviceProviderId=2
    final dbClient = DbClient('getOrders', serverPort: 3001);
    final orders = await dbClient.get(queryParams: {
      'serviceProviderId': serviceProviderId.toString(),
    });

    return orders.map<Order>((orderJson) => Order.fromJson(orderJson)).toList();
  }

  Future<List<ItemOrder>> getOrderDetails(int orderId) async {
    // http://localshopwala.com:3001/getOrderDetails?orderId=13
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
    // http://localshopwala.com:3001/updateOrderStatus
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
  Future<List<Order>> getOrders(int serviceProviderId) => Future.value(
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
