import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/lib/provider.dart';
import 'package:shared/services/lib/catalog.dart';
import 'package:local/widgets/lib/catalog.dart';

@injectable
class ProviderCardFactory {
  final CatalogService _catalogService;
  final CatalogFactory _catalogFactory;

  ProviderCardFactory(this._catalogService, this._catalogFactory);

  ProviderCard create(Provider _provider) =>
      ProviderCard(_catalogService, _provider, _catalogFactory);
}

class ProviderCard extends StatelessWidget {
  final CatalogService _catalogService;
  final Provider _provider;
  final CatalogFactory _catalogFactory;

  ProviderCard(this._catalogService, this._provider, this._catalogFactory);

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

            final _items = await _catalogService.byProviderId(_provider.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    _catalogFactory.create(provider: _provider, items: _items),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            height: 100,
            child: Center(
              child: Text(
                _provider?.name ?? '',
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
