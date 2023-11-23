import 'package:local_genie_vendor/api_properties.dart';
import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/models/order_status_modal.dart';
import 'package:local_genie_vendor/services/http_service.dart';

Future<List<OrderStatusM>> getOrderStatus() async {
  try {
    final httpService = HttpService(ORDER_STATUS, 2);

    var orderStatus = (await httpService.get());

    orderStatus = [
      {"name": "All", "id": 0},
      ...orderStatus['data'],
    ];

    print(orderStatus.toString());

    return orderStatus
        .map<OrderStatusM>(
            (orderStatusJson) => OrderStatusM.fromJson(orderStatusJson))
        .toList();
  } catch (e) {
    print(e.toString());
    throw e.toString();
  }
}

Future<OrderDetailsI> getOrderDetails(String orderId) async {
  try {
    final httpService = HttpService(ORDER_DETAILS, 1);

    var orderDetails = (await httpService
        .get(queryParams: {"orderId": orderId, "customer": "true"}));

    print(orderDetails.toString());

    return OrderDetailsI.fromJson(orderDetails);
  } catch (e) {
    print(e.toString());
    throw e.toString();
  }
}
