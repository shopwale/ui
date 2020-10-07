import 'package:vendor/models/lib/catalog.dart';
import 'package:vendor/models/lib/order.dart';

abstract class OrderService {
  Future<List<Order>> getOrders(int serviceProviderId);
}

class FakeOrderService implements OrderService {
  @override
  Future<List<Order>> getOrders(int serviceProviderId) =>
      Future.value(List.generate(20, (index) => createFakeOrder(index)));

  Order createFakeOrder(int orderId) => Order(
        serviceProviderId: 1,
        customerId: 1,
        orderId: orderId,
        itemOrders: [
          ItemOrder(
              item: CatalogItem(
                id: 1,
                name: 'Onion',
                unitOfMeasure: Unit.kg,
              ),
              quantity: 1),
          ItemOrder(
              item: CatalogItem(
                id: 2,
                name: 'Tomato',
                unitOfMeasure: Unit.kg,
              ),
              quantity: 3)
        ],
      );
}
