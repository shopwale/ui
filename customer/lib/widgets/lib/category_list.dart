import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:local/widgets/lib/current_orders.dart';
import 'package:shared/models/category.dart';
import 'package:shared/services/category.dart';

import 'category_card.dart';

@injectable
class CategoryListFactory {
  final CategoryService _categoryService;
  final CategoryCardFactory _cardFactory;
  final CurrentOrdersFactory _currentOrdersFactory;

  CategoryListFactory(
    this._categoryService,
    this._cardFactory,
    this._currentOrdersFactory,
  );

  CategoryList create({Key key}) =>
      CategoryList(_categoryService, _cardFactory, _currentOrdersFactory);
}

class CategoryList extends StatelessWidget {
  final CategoryService _categoryService;
  final CategoryCardFactory _cardFactory;
  final CurrentOrdersFactory _currentOrdersFactory;

  CategoryList(
    this._categoryService,
    this._cardFactory,
    this._currentOrdersFactory,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _currentOrdersFactory.create(customerId: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Services')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: FutureBuilder<List<Category>>(
            future: _categoryService.getAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final categories = snapshot.data;
              return GridView.extent(
                maxCrossAxisExtent: 250,
                children:
                    categories.map((c) => _cardFactory.create(c)).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
