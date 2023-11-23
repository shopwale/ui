import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/providers/order_provider.dart';

final orderScrollControllerProvider = StateProvider((ref) {
  final scrollController = ScrollController();
  Future<void> scrollListener() async {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent - 100 &&
        !scrollController.position.outOfRange) {
      ref.read(ordersStateProvider.notifier).getOrders();
      //
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {}
  }

  scrollController.addListener(scrollListener);
  ref.onDispose(() {
    scrollController.removeListener(scrollListener);
  });
  return scrollController;
});
