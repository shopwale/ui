import 'dart:math';

import 'package:vendor/models/lib/catalog.dart';
import 'package:vendor/models/lib/order.dart';

abstract class OrderService {
  Future<List<Order>> getOrders(int serviceProviderId);

  Future<List<ItemOrder>> getOrderDetails(int orderId);
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
        orderStatus: OrderStatus.values[_rnd.nextInt(4)],
        isDelivery: _rnd.nextBool(),
        totalPrice: (_rnd.nextInt(10) + 1) * 700.0,
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
        subTotalPrice: (_rnd.nextInt(10) + 1) * 100.0,
      );
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
