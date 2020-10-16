import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:vendor/common/lib/constants.dart';
import 'package:vendor/models/lib/order.dart';
import 'package:vendor/services/lib/customer.dart';
import 'package:vendor/services/lib/order.dart';
import 'package:vendor/types/lib/inject.dart';
import 'package:vendor/widgets/lib/order_details.dart';
import 'package:intl/intl.dart';

@provide
class CurrentOrdersFactory {
  final Provider<CurrentOrdersState> stateProvider;

  CurrentOrdersFactory(this.stateProvider);

  CurrentOrders create({@required List<Order> orders}) =>
      CurrentOrders(stateProvider(), orders: orders);
}

class CurrentOrders extends StatefulWidget {
  final List<Order> orders;
  final CurrentOrdersState state;

  CurrentOrders(
    this.state, {
    Key key,
    @required this.orders,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

@provide
class CurrentOrdersState extends State<CurrentOrders> {
  final OrderService orderService;
  final CustomerService customerService;
  final OrderDetailsFactory orderDetailsFactory;

  bool showDeliveryOrders = false;
  bool showPickupOrders = false;
  Set<OrderStatusEnum> statusesToFilter = {
    OrderStatusEnum.pending,
    OrderStatusEnum.accepted,
  };
  List<Order> visibleOrders = [];

  CurrentOrdersState(
    this.orderService,
    this.orderDetailsFactory,
    this.customerService,
  );

  @override
  void initState() {
    super.initState();
    _updateVisibleOrders();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('hh:mm, dd MMM');

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 8.0),
          _buildStatusFilters(),
          _buildTypeFilters(),
          ...visibleOrders
              .map(
                (o) => GestureDetector(
                  onTap: () async {
                    final details = await Future.wait([
                      orderService.getOrderDetails(o.orderId),
                      customerService.getCustomerById(o.customerId)
                    ]);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => orderDetailsFactory.create(
                          order: o,
                          itemOrders: details[0],
                          customer: details[1],
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
        ],
      ),
    );
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
    visibleOrders =
        widget.orders.where((order) => _filterOrder(order)).toList();
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
