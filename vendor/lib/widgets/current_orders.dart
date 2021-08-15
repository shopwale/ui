import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/catalog.dart';
import 'package:shared/models/order.dart';
import 'package:shared/services/customer.dart';
import 'package:shared/services/order.dart';
import 'package:vendor/common/constants.dart';
import 'package:vendor/widgets/order_details.dart';
import 'package:intl/intl.dart';

@injectable
class CurrentOrdersFactory {
  const CurrentOrdersFactory();

  CurrentOrders create({
    @required int serviceProviderId,
    @required List<CatalogItem> catalogItems,
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
    Key key,
    @required this.serviceProviderId,
    @required this.catalogItems,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

@injectable
class CurrentOrdersState extends State<CurrentOrders> {
  final OrderService orderService;
  final CustomerService customerService;
  final OrderDetailsFactory orderDetailsFactory;

  List<Order> orders;
  bool showDeliveryOrders = false;
  bool showPickupOrders = false;
  Set<OrderStatusEnum> statusesToFilter = {
    OrderStatusEnum.pending,
    OrderStatusEnum.accepted,
  };
  List<Order> visibleOrders = [];
  Timer _timer;

  CurrentOrdersState(
    this.orderService,
    this.orderDetailsFactory,
    this.customerService,
  );

  @override
  void initState() {
    super.initState();
    _fetchOrdersAndUpdateState();

    _timer = Timer.periodic(
      Duration(minutes: 1),
      (_) => _fetchOrdersAndUpdateState(),
    );
  }

  Future<void> _fetchOrdersAndUpdateState() async {
    orders = await orderService.getOrders(widget.serviceProviderId);
    setState(() {
      _updateVisibleOrders();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('hh:mm, dd MMM');

    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).accentColor,
        ),
        child: IconButton(
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).accentTextTheme.subtitle1.color,
          ),
          onPressed: () => _refreshOrders(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          _buildStatusFilters(),
          _buildTypeFilters(),
          Flexible(
            child: RefreshIndicator(
              onRefresh: _fetchOrdersAndUpdateState,
              child: ListView(
                children: visibleOrders
                    .map(
                      (o) => GestureDetector(
                        onTap: () async {
                          final details = await Future.wait([
                            orderService.getOrderDetails(o.orderId),
                            customerService.getCustomerById(o.customerId),
                          ]);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => orderDetailsFactory.create(
                                order: o,
                                itemOrders: details[0],
                                customer: details[1],
                                catalogItems: widget.catalogItems,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          key: Key(o.orderId.toString()),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 16.0, left: 16.0),
                                alignment: Alignment.topLeft,
                                child: Text(formatter.format(o.orderDate)),
                              ),
                              ListTile(
                                leading: Icon(
                                  o.isDelivery
                                      ? Icons.delivery_dining
                                      : Icons.shopping_bag,
                                  color: o.isDelivery
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5),
                                ),
                                title: Text('${o.customerName}'),
                                subtitle: Text('${o.orderStatus.asString()}'),
                                trailing: Text('$rupeeSymbol ${o.totalPrice}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshOrders(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Center(
          child: RefreshProgressIndicator(key: Key('LoadingOverlay')),
        ),
      ),
    );
    try {
      await _fetchOrdersAndUpdateState();
    } finally {
      Navigator.of(context).pop();
    }
  }

  Widget _buildStatusFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text('status:'),
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
          _buildStatusFilter(OrderStatusEnum.pending),
          _buildStatusFilter(OrderStatusEnum.rejected),
          _buildStatusFilter(OrderStatusEnum.accepted),
          // _buildStatusFilter(OrderStatusEnum.completed),
        ],
      ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text('type:'),
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
      ),
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
