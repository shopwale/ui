import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/services/http_service.dart';

class OrderController {
  const OrderController();

  Future<bool> changeOrderStatus(String status, String orderId) async {
    try {
      final httpService = HttpService('updateOrderStatus', 2);

      print("Status: $status");
      print("Order Id: $orderId");

      await httpService.post(body: {"orderId": orderId, "orderStatus": status});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Order>> getOrders({int status = 1}) async {
    try {
      final httpService = HttpService('getOrdersByStatus', 2);

      final orders = await httpService.get(queryParams: {
        "status": status.toString(),
        "serviceProviderId": 2.toString()
      });

      print(orders.toString());

      dynamic _oders =
          orders.map<Order>((orderJson) => Order.fromJson(orderJson)).toList();

      print(_oders);

      return _oders;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> placeOrder(String paymentVia, String address) async {
    try {
      final httpService = HttpService('order', 1);

      final order = await httpService
          .post(body: {"payment_via": paymentVia, "address": address});

      return order != null && order['order'] != null
          ? order['order'].cast<String>()
          : [];
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
