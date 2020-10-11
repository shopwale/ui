import 'package:vendor/models/lib/catalog.dart';
import 'package:vendor/models/lib/order.dart';

abstract class OrderService {
  Future<List<Order>> getOrders(int serviceProviderId);

  Future<List<ItemOrder>> getOrderDetails(int orderId);
}

class FakeOrderService implements OrderService {
  @override
  Future<List<Order>> getOrders(int serviceProviderId) =>
      Future.value(List.generate(20, (index) => createFakeOrder(index)));

  Order createFakeOrder(int orderId) => Order(
        customerId: 1,
        orderId: orderId,
        orderDate: DateTime.now(),
        orderStatus: [
          'Pending',
          'Accepted',
          'Declined',
          'Completed'
        ][orderId % 4],
        isDelivery: orderId % 3 == 0,
        totalPrice: orderId * 35.5 + 10,
        customerName: 'Vimal K',
      );

  @override
  Future<List<ItemOrder>> getOrderDetails(int orderId) => Future.value(
        [
          ItemOrder(
            item: CatalogItem(
              name: 'Onion',
              id: 1,
            ),
            quantity: 2,
            subTotalPrice: 20.0,
          )
        ],
      );
}
