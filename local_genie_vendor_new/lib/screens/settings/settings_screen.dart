import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isReadyToTakeOrder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: appBar('Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: Colors.green,
              ),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.green),
              onTap: () => Navigator.of(context).pushNamed("/profile"),
            ),
            const Divider(color: Colors.green),
            ListTile(
              leading: const Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Colors.green,
              ),
              title: const Text(
                "Ready to take order",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                isReadyToTakeOrder
                    ? Icons.toggle_on_sharp
                    : Icons.toggle_off_sharp,
                color: isReadyToTakeOrder ? Colors.green : Colors.red,
                size: 50,
              ),
              onTap: () {
                setState(() {
                  isReadyToTakeOrder = !isReadyToTakeOrder;
                });
              },
            ),
            const Divider(color: Colors.green),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ListTile(
                  leading: const Icon(Icons.logout, color: Colors.green),
                  title: const Text("Logout",
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    try {
                      // await logout();
                      // ref.read(cartStateProvider.notifier).resetCarts();
                      // ref
                      //     .read(favouriteStateProvider.notifier)
                      //     .resetFavourites();
                      // ref.read(ordersStateProvider.notifier).resetOrders();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    } catch (e) {}
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
