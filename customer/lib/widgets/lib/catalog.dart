import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/lib/catalog.dart';
import 'package:shared/models/lib/order.dart';
import 'package:shared/models/lib/provider.dart';
import 'package:local/widgets/lib/catalog_item.dart';
import 'package:local/widgets/lib/checkout.dart';

@injectable
class CatalogFactory {
  final CheckoutFactory _checkoutFactory;

  CatalogFactory(this._checkoutFactory);

  Catalog create(
          {@required Provider provider, @required List<CatalogItem> items}) =>
      Catalog(provider, items, _checkoutFactory);
}

class Catalog extends StatelessWidget {
  final Provider _provider;
  final Map<String, List<CatalogItem>> _items;
  final Order _order;
  final CheckoutFactory _checkoutFactory;

  Catalog(this._provider, List<CatalogItem> items, this._checkoutFactory)
      : _order = Order(serviceProviderId: _provider.id),
        _items = items.fold(
          {},
          (value, element) {
            final subCategoryName = element.subCategoryName;
            if (value[subCategoryName] == null) {
              value[subCategoryName] = [];
            }

            value[subCategoryName].add(element);

            return value;
          },
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_provider.name)),
      floatingActionButton: _buildCheckoutButton(context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: _items.values.map(
              (itemsList) {
                return ExpansionTile(
                  title: Text(
                    itemsList[0].subCategoryName,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    ),
                  ),
                  children: itemsList.map(
                    (i) {
                      final newItemOrder = ItemOrder(item: i);
                      _order.addItemOrder(newItemOrder);
                      return CatalogItemTile(
                        catalogItem: i,
                        itemOrder: newItemOrder,
                      );
                    },
                  ).toList(),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  MaterialButton _buildCheckoutButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        print('Checkout button pressed.');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _checkoutFactory.create(_order),
          ),
        );
      },
      child: Text('Checkout'),
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
    );
  }
}
