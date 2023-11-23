import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/order_status_modal.dart';
import 'package:local_genie_vendor/providers/scroll_controller_provider.dart';
import 'package:local_genie_vendor/screens/orders/orders_screen.dart';
import 'package:local_genie_vendor/widgets/app_bar.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';
import 'package:local_genie_vendor/widgets/no_internet_connection.dart';

import 'package:local_genie_vendor/providers/order_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getTabar(List<OrderStatusM> data, WidgetRef ref) {
    return TabBar(
        labelStyle: const TextStyle(fontSize: 12.0),
        unselectedLabelStyle: const TextStyle(fontSize: 10.0),
        labelColor: Colors.white,
        unselectedLabelColor: PrimarySwatch.shade100,
        isScrollable: true,
        onTap: (value) {
          ref.read(orderStatusSelectedProvider.notifier).state = data[value];
          ref
              .read(ordersStateProvider.notifier)
              .getOrders(status: data[value].id, start: true);
        },
        tabs: [...data.map((e) => Tab(text: getTabName(e.name)))]);
  }

  String getTabName(String name) {
    if (orderStatusMap.keys.contains(name)) {
      return orderStatusMap.entries
          .firstWhere((element) => element.key == name)
          .value['name'];
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final orderStatus = ref.watch(orderStatusProvider);
            // final controller = ref.watch(orderScrollControllerProvider);
            return orderStatus.when(
              data: (List<OrderStatusM> data) {
                return DefaultTabController(
                  length: data.length,
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                    // controller: controller,
                    physics: const ScrollPhysics(parent: PageScrollPhysics()),
                    body: const SingleChildScrollView(child: OrdersScreen()),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          pinned: true,
                          floating: true,
                          backgroundColor: darkBlue,
                          // foregroundColor: darkBlue,
                          scrolledUnderElevation: 0,
                          flexibleSpace: SizedBox(
                            height: 50,
                            child: getTabar(data, ref),
                          ),
                        ),
                      ];
                    },
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                print(error.toString());
                return const NoInternetConnection();
              },
              loading: () => CircularProgress(),
            );
          },
        ),
      ),
    );
  }
}
