import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/controllers/order_controller.dart';
import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/models/pagination_modal.dart';

class OrderStateNotifier extends StateNotifier<PaginationModal> {
  final _orderController = const OrderController();

  OrderStateNotifier() : super(PaginationModal.unknown()) {
    state = const PaginationModal(
      results: [],
      isLoading: false,
      limit: 10,
      page: 0,
    );
    getOrders();
  }

  void resetOrders() {
    state = PaginationModal(
      results: [],
      isLoading: false,
      limit: state.limit,
      page: 0,
    );
  }

  Future<void> getOrders({bool start = false, int status = 0}) async {
    if (state.isLoading) return;
    if (start) {
      resetOrders();
    }

    print("status: " + status.toString());

    state = state.copiedWithIsLoading(true);
    var results = [], page = 0;

    try {
      results = await _orderController.getOrders(status: status);
      page = 1;
    } catch (e) {}

    print(results.toString());
    state = PaginationModal(
      results: results,
      isLoading: false,
      limit: state.limit,
      page: start ? 0 : state.page + page,
    );
  }

  Future<List<String>> placeOrder({
    String paymentVia = "",
    String address = "",
  }) async {
    state = state.copiedWithIsLoading(true);
    var orderId;

    try {
      orderId = await _orderController.placeOrder(paymentVia, address);
    } catch (e) {}
    state = state.copiedWithIsLoading(false);
    return orderId;
  }

  Future<bool> changeOrderStatus(String status, String orderId) async {
    print("Status: $status");
    print("Order Id: $orderId");
    var changed = false;
    try {
      changed = await _orderController.changeOrderStatus(status, orderId);
      print("Changed status: $changed");
    } catch (e) {
      print(e.toString());
    }

    if (changed) {
      var results = [];

      results = state.results;

      state.results.removeWhere((value) => value.orderId == orderId);
      results = [...results];

      state = PaginationModal(
        results: results,
        isLoading: false,
        limit: state.limit,
        page: state.page,
      );
    }
    return changed;
  }
}
