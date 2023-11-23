import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/providers/order_provider.dart';
import 'package:local_genie_vendor/screens/orders/order_card_screen.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      margin: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Consumer(
        builder: (context, ref, child) {
          final orders = ref.watch(ordersProvider);
          final loading = ref.watch(isFetchingOrderProvider);
          if (!loading && orders.isEmpty) {
            return const Center(
              child: Text(
                "No orders!!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 16.0, // gap between adjacent chips
            runSpacing: 16.0, // gap between lines
            children: [
              ...orders.map((e) => OrderCard(order: e)),
              if (loading) CircularProgress()
            ],
          );
        },
      ),
    );
  }
}
