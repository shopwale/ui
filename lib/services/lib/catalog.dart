import 'package:shared/models/lib/catalog.dart';
import 'db.dart';

class CatalogService {
  final DbClient _dbClient;

  CatalogService() : _dbClient = DbClient('getItems');

  Future<List<CatalogItem>> byProviderId(int id) async {
    // http://localshopwala.com:3000/getItems?serviceprovider=2
    final List itemsJson = await _dbClient.get(queryParams: {
      'serviceProviderId': id.toString(),
    });
    return itemsJson.map((i) => CatalogItem.fromJson(i)).toList();
  }
}

class FakeCatalogService extends CatalogService {
  @override
  Future<List<CatalogItem>> byProviderId(int id) {
    return Future.value([
      CatalogItem(
        name: 'Onion',
        id: 1,
        unitOfMeasure: Unit.kg,
        price: 10,
        subCategoryName: 'Grocery',
      ),
      CatalogItem(
        name: 'Tomato',
        id: 2,
        unitOfMeasure: Unit.kg,
        price: 20,
        subCategoryName: 'Grocery',
      ),
      CatalogItem(
        name: 'Soap',
        id: 3,
        price: 30,
        subCategoryName: 'Grocery',
      ),
      CatalogItem(
        name: 'Shampoo',
        id: 4,
        price: 15,
        subCategoryName: 'Grocery',
      ),
      CatalogItem(
        name: 'Dal',
        id: 5,
        unitOfMeasure: Unit.kg,
        price: 34,
        subCategoryName: 'Grocery',
      ),
    ]);
  }
}
