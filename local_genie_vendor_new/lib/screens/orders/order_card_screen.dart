import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/services/app_service.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Widget getOrderStatus(bool isDeliver) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        isDeliver ? "D" : "P",
        style: const TextStyle(
          fontSize: 40,
          color: PrimarySwatch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/order_details', arguments: {"orderId": order.orderId});
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green, width: 1),
          ),
          width: (MediaQuery.of(context).size.width - 40),
          // color: Colors.white,
          child: Row(
            children: [
              getOrderStatus(order.isDeliver),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Order Number: ${order.orderId}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatNumber(order.totalPrice),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    order.orderDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${order.status} (Updated ${timeElapsed(order.lastStatusUpdated)} ago)",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
