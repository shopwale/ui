import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/models/category.dart';
import 'package:shared/models/provider.dart';
import 'package:local/widgets/lib/provider_card.dart';

@injectable
class ProviderListFactory {
  final ProviderCardFactory _providerCardFactory;

  ProviderListFactory(this._providerCardFactory);

  ProviderList create(
          {@required Category category, @required List<Provider> providers}) =>
      ProviderList(_providerCardFactory, category, providers);
}

class ProviderList extends StatelessWidget {
  final ProviderCardFactory _providerCardFactory;
  final Category _category;
  final List<Provider> _providers;

  ProviderList(this._providerCardFactory, this._category, this._providers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_category.name)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: _providers.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.amberAccent),
                    SizedBox(width: 8),
                    Text(
                      'No service provider for \'${_category.name}\'',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize *
                                1.5,
                      ),
                    )
                  ],
                )
              : ListView(
                  children: _providers
                      .map((s) => _providerCardFactory.create(s))
                      .toList(),
                ),
        ),
      ),
    );
  }
}
