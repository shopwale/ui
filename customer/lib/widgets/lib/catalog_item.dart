import 'package:flutter/material.dart';
import 'package:local/common/lib/constants.dart';
import 'package:shared/models/lib/catalog.dart';
import 'package:shared/models/lib/order.dart';

class CatalogItemTile extends StatefulWidget {
  final CatalogItem catalogItem;
  final ItemOrder itemOrder;

  const CatalogItemTile({
    Key key,
    @required this.catalogItem,
    this.itemOrder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CatalogItemTileState();
}

class CatalogItemTileState extends State<CatalogItemTile> {
  int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.itemOrder.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.catalogItem.name,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '$rupeeSymbol ${widget.catalogItem.price} / ${widget.catalogItem.unitOfMeasure.asString()}',
              ),
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: quantity == 0
                    ? null // disable button.
                    : () {
                        setState(() {
                          widget.itemOrder.decrement();
                          quantity--;
                          print('quantity: ${widget.itemOrder.quantity}');
                        });
                      },
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(quantity.toString()),
                ),
              ),
              IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    widget.itemOrder.increment();
                    quantity++;
                    print('quantity: ${widget.itemOrder.quantity}');
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
