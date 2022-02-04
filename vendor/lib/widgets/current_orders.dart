import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/catalog.dart';
import 'package:shared/models/order.dart';
import 'package:shared/services/customer.dart';
import 'package:shared/services/order.dart';
import 'package:strings/strings.dart';
import 'package:vendor/widgets/loading_overlay.dart';
import 'package:vendor/widgets/order_details.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'error_snack_bar.dart';

@injectable
class CurrentOrdersFactory {
  const CurrentOrdersFactory();

  CurrentOrders create({
    required int serviceProviderId,
    required List<CatalogItem> catalogItems,
  }) =>
      CurrentOrders(
        GetIt.instance<CurrentOrdersState>(),
        serviceProviderId: serviceProviderId,
        catalogItems: catalogItems,
      );
}

class CurrentOrders extends StatefulWidget {
  final int serviceProviderId;
  final List<CatalogItem> catalogItems;
  final CurrentOrdersState state;

  CurrentOrders(
    this.state, {
    Key? key,
    required this.serviceProviderId,
    required this.catalogItems,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

@injectable
class CurrentOrdersState extends State<CurrentOrders> {
  final OrderService orderService;
  final CustomerService customerService;
  final OrderDetailsFactory orderDetailsFactory;
  List<Order> orders = [];
  bool showDeliveryOrders = false;
  bool showPickupOrders = false;
  Set<OrderStatusEnum> statusesToFilter = {};
  List<Order> visibleOrders = [];
  late Timer _timer;
  // Filter orders in last N number of days.
  int numberOfDays = 1;
  bool showFilters = false;

  CurrentOrdersState(
    this.orderService,
    this.orderDetailsFactory,
    this.customerService,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _fetchOrdersAndUpdateState);

    _timer = Timer.periodic(
      Duration(minutes: 2),
      (_) => _fetchOrdersAndUpdateState(shouldShowLoadingOverlay: false),
    );
  }

  Future<void> _fetchOrdersAndUpdateState({
    bool shouldShowLoadingOverlay = true,
  }) async {
    showLoadingOverlay(context);

    try {
      orders = await orderService.getOrders(
        widget.serviceProviderId,
        fromDate: DateTime.now().subtract(Duration(days: numberOfDays)),
      );

      setState(() {
        _updateVisibleOrders();
      });
    } catch (error) {
      showError(context, 'Error fetching order details.');
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.secondary),
        child: IconButton(
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).accentTextTheme.subtitle1?.color,
          ),
          onPressed: _fetchOrdersAndUpdateState,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            ExpansionPanelList(
              expansionCallback: (_, isExpanded) {
                setState(() {
                  showFilters = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: showFilters,
                  headerBuilder: (_, __) => ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.filter_list),
                        SizedBox(width: 8),
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusFilters(),
                        _buildTypeFilters(),
                        _buildNumberOfDaysFilter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible: !showFilters, // hidden as info would be redundant.
              child: Text(
                'Orders from last $numberOfDays day(s)',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8.0),
            Flexible(
              child: RefreshIndicator(
                onRefresh: _fetchOrdersAndUpdateState,
                child: visibleOrders.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded),
                            Container(width: 8, height: 0),
                            Text(
                              'No orders. Please check filters.',
                              style: TextStyle(fontSize: 16),
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: visibleOrders
                            .map((order) => _orderTile(order, context))
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<dynamic> _buildNumberOfDaysFilter() {
    return DropdownButton(
      value: numberOfDays,
      items: [1, 2, 3, 5, 10, 15, 30, 90]
          .map<DropdownMenuItem>(
            (value) => DropdownMenuItem<int>(
              value: value,
              child: Text('last $value day(s)'),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        setState(() {
          numberOfDays = newValue;
        });
        _fetchOrdersAndUpdateState();
      },
    );
  }

  GestureDetector _orderTile(Order order, BuildContext context) {
    final formatter = DateFormat('hh:mm, dd MMM');

    return GestureDetector(
      onTap: () => _openOrderDetails(order, context),
      child: Card(
        key: Key(order.orderId.toString()),
        child: Column(
          children: [
            _orderDate(formatter, order),
            ListTile(
              isThreeLine: true,
              leading: _orderTypeIcon(order, context),
              title: Text('${order.customerName.trim()}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order    #${order.orderId}'),
                  Text('Status   ${capitalize(order.orderStatus.asString())}'),
                ],
              ),
              trailing: _callButton(order.customerId),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _callButton(int customerId) => IconButton(
      icon: Icon(Icons.phone_callback),
      onPressed: () async {
        final mobileNumber =
            (await customerService.getCustomerById(customerId)).mobileNumber;
        launch("tel://+$mobileNumber");
      });

  Container _orderDate(DateFormat formatter, Order order) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, left: 16.0),
      alignment: Alignment.topLeft,
      child: Text(formatter.format(order.orderDate)),
    );
  }

  Future _openOrderDetails(Order order, BuildContext context) async {
    showLoadingOverlay(context);

    List details = [];
    try {
      details = await Future.wait([
        orderService.getOrderDetails(order.orderId),
        customerService.getCustomerById(order.customerId),
      ]);
    } catch (error) {
      showError(context, 'Error fetching order details.');
    } finally {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => orderDetailsFactory.create(
          order: order,
          itemOrders: details[0],
          customer: details[1],
          catalogItems: widget.catalogItems,
        ),
      ),
    );
  }

  Icon _orderTypeIcon(Order o, BuildContext context) {
    return Icon(
      o.isDelivery ? Icons.delivery_dining : Icons.shopping_bag,
      color: o.isDelivery
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    );
  }

  Widget _buildStatusFilters() {
    return Wrap(
      spacing: 8.0,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          child: Text(
            'Status',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ChoiceChip(
          label: Text('all'),
          selected: statusesToFilter.isEmpty,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                statusesToFilter = <OrderStatusEnum>{};
                _updateVisibleOrders();
              });
            }
          },
        ),
        ...OrderStatusEnum.values.map(_buildStatusFilter).toList(),
      ],
    );
  }

  ChoiceChip _buildStatusFilter(OrderStatusEnum status) {
    return ChoiceChip(
      label: Text(status.asString()),
      selected: statusesToFilter.contains(status),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            statusesToFilter.add(status);
          } else {
            statusesToFilter.remove(status);
          }

          _updateVisibleOrders();
        });
      },
    );
  }

  Widget _buildTypeFilters() {
    return Wrap(
      spacing: 8.0,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          child: Text(
            'Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ChoiceChip(
          label: Text('all'),
          selected: !showDeliveryOrders && !showPickupOrders,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                showDeliveryOrders = false;
                showPickupOrders = false;
                _updateVisibleOrders();
              }
            });
          },
        ),
        ChoiceChip(
          label: Text('delivery'),
          selected: showDeliveryOrders,
          onSelected: (selected) {
            setState(() {
              showDeliveryOrders = selected;
              _updateVisibleOrders();
            });
          },
        ),
        ChoiceChip(
          label: Text('pickup'),
          selected: showPickupOrders,
          onSelected: (selected) {
            setState(() {
              showPickupOrders = selected;
              _updateVisibleOrders();
            });
          },
        ),
      ],
    );
  }

  void _updateVisibleOrders() {
    visibleOrders = orders.where((order) => _filterOrder(order)).toList();
  }

  bool _filterOrder(Order order) {
    bool predicate = true;

    if (!showDeliveryOrders || !showPickupOrders) {
      if (showDeliveryOrders) {
        predicate = predicate && order.isDelivery;
      }

      if (showPickupOrders) {
        predicate = predicate && !order.isDelivery;
      }
    }

    if (statusesToFilter.isNotEmpty) {
      predicate = predicate && statusesToFilter.contains(order.orderStatus);
    }

    return predicate;
  }
}
