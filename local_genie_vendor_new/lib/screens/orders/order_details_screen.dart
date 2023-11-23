import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/providers/order_provider.dart';
import 'package:local_genie_vendor/services/app_service.dart';
import 'package:local_genie_vendor/widgets/app_bar.dart';
import 'package:local_genie_vendor/widgets/border_button.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';
import 'package:local_genie_vendor/widgets/filled_button.dart';
import 'package:local_genie_vendor/widgets/network_image.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  String orderId;
  OrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(orderDetailsProvider(widget.orderId));
  }
  // OrderDetailsI? orderDetails;

  Widget bottomAction(OrderDetailsI? orderDetails) {
    var status = orderDetails?.orderStatus ?? "";
    var isDeliver = orderDetails?.isDeliver ?? false;
    var nextStatus = getNextStatus(status, isDeliver);

    print("bottomAction: status=$status nextStatus: $nextStatus");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (canCancelOrder(status))
          CustomBorderButton(
            context,
            text: "Reject",
            color: Colors.red,
            screenWidth: 2,
            fontSize: 14,
            onPressed: () async {
              await changeStatus("Rejected", orderDetails);
            },
          ),
        if (!canCancelOrder(status)) const Text(""),
        if (nextStatus != "")
          CustomFilledButton(
            context,
            text: getStatus(nextStatus),
            // color: ,
            screenWidth: 2,
            fontSize: 14,
            onPressed: () async {
              await changeStatus(nextStatus, orderDetails);
            },
          ),
      ],
    );
  }

  Future<void> changeStatus(String status, OrderDetailsI? orderDetails) async {
    var changed = await ref
        .read(ordersStateProvider.notifier)
        .changeOrderStatus(status, widget.orderId);
    print("changed last: $changed");

    if (changed) {
      ref.read(selectedOrderProvider.notifier).state =
          orderDetails?.copyWithStatus(status);
    }
  }

  bool canCancelOrder(status) {
    // if (["Cancelled", "Rejected", "Completed"].contains(status)) return false;
    return ["Pending"].contains(status);
  }

  String getStatus(String status) {
    return (orderStatusMap.entries
            .firstWhere((element) => element.key == status)
            .value['shortName'] ??
        "");
  }

  String getNextStatus(String status, bool isDeliver) {
    var changedStatus = "";

    switch (status) {
      case "Pending":
        changedStatus = "Accepted";
        break;
      case "Accepted":
        changedStatus = "InProgress";
        break;
      case "InProgress":
        changedStatus = isDeliver ? "OutToDeliver" : "ReadyToPick";
        break;
      case "OutToDeliver":
        changedStatus = "Completed";
        break;
      case "ReadyToPick":
        changedStatus = "Completed";
        break;
      case "Rejected":
        changedStatus = "";
        break;
      case "Completed":
        changedStatus = "";
        break;
      case "Cancelled":
        changedStatus = "";
        break;
      default:
        changedStatus = status;
    }

    return changedStatus;
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder = ref.watch(selectedOrderProvider);
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: appBar("#${widget.orderId}", actions: [
        if ((selectedOrder?.customer.mobileNumber ?? "") != "")
          MaterialButton(
            child: Transform.rotate(
              angle: 270 * pi / 180,
              child: const Icon(
                Icons.call_outlined,
                color: PrimarySwatch,
              ),
            ),
            onPressed: () async {
              try {
                print(
                    "Mobile: ${(selectedOrder?.customer.mobileNumber ?? "").toString()}");
                if ((selectedOrder?.customer.mobileNumber ?? "") != "") {
                  await openDialPad(
                      (selectedOrder?.customer.mobileNumber ?? ""));
                }
              } catch (e) {
                print(e.toString());
              }
              print("object");
            },
          ),
        if ((selectedOrder?.customer.mobileNumber ?? "") == "") const Text("")
      ]),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: selectedOrder == null
              ? CircularProgress()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ordered On:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              getDate((selectedOrder?.orderDate ?? "")),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Order Type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              (selectedOrder?.isDeliver ?? false)
                                  ? "Deliver"
                                  : "Pickup",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Delivery Address: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (selectedOrder.customer.customerName),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (selectedOrder.customer.address),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (selectedOrder.customer.pinCode),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Items: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(selectedOrder.items).map(
                      (e) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.white60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      networkImage(e.itemIconURL,
                                          height: 50, width: 50),
                                      const SizedBox(width: 20),
                                      Text(
                                          "${e.itemName} (${e.quantity} ${e.unitOfMeasure})"),
                                    ],
                                  ),
                                  Text(
                                    formatNumber(e.subTotalPrice),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Total: ${formatNumber(selectedOrder?.totalPrice ?? 0)}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30),
        color: Colors.transparent,
        elevation: 0,
        child: bottomAction(selectedOrder),
      ),
    );
  }
}
