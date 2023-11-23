import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/models/order_status_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/models/pagination_modal.dart';
import 'package:local_genie_vendor/notifiers/order_notifier.dart';
import 'package:local_genie_vendor/services/order_status_service.dart';

final ordersStateProvider =
    StateNotifierProvider<OrderStateNotifier, PaginationModal>(
  (ref) => OrderStateNotifier(),
);

final ordersProvider =
    Provider.autoDispose((ref) => ref.watch(ordersStateProvider).results);

final orderStatusProvider = FutureProvider.autoDispose((ref) async {
  return await getOrderStatus();
});

final isFetchingOrderProvider =
    StateProvider((ref) => ref.watch(ordersStateProvider).isLoading);

final orderStatusSelectedProvider =
    StateProvider((ref) => OrderStatusM(name: "All", id: 0));

final orderDetailsProvider =
    FutureProvider.autoDispose.family((ref, String orderId) async {
  OrderDetailsI orderDetails = await getOrderDetails(orderId);
  ref.read(selectedOrderProvider.notifier).state = orderDetails;
  return orderDetails;
});

final selectedOrderProvider = StateProvider<OrderDetailsI?>((ref) => null);
