import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:shared/models/lib/category.dart';
import 'package:shared/services/lib/provider.dart';
import 'package:local/widgets/lib/provider_list.dart';

@provide
class CategoryCardFactory {
  final ProviderService _providerService;
  final ProviderListFactory _providerListFactory;

  CategoryCardFactory(this._providerService, this._providerListFactory);

  CategoryCard create(Category category) =>
      CategoryCard(_providerService, _providerListFactory, category);
}

class CategoryCard extends StatelessWidget {
  final ProviderService _providerService;
  final ProviderListFactory _providerListFactory;
  final Category _category;

  CategoryCard(
      this._providerService, this._providerListFactory, this._category);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Card(
        color: Theme.of(context).bottomAppBarColor,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            print('Card tapped.');

            final _providers =
                await _providerService.byCategoryId(_category.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _providerListFactory.create(
                  category: _category,
                  providers: _providers,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                _category.name,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline5.fontSize,
                    color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
