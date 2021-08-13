import 'package:shared/models/lib/provider.dart';
import 'package:shared/services/lib/db.dart';

class ProviderService {
  Future<Provider> getServiceProviderInfo(int mobileNumber) async {
    // http://localgenie.in:3001/getServiceProviderInfo?serviceProviderMobile=989898934
    final dbClient = DbClient('getServiceProviderInfo', serverPort: 3001);
    final jsonResponse = await dbClient
        .get(queryParams: {'serviceProviderMobile': mobileNumber.toString()});

    return Provider.fromJson(jsonResponse);
  }

  Future<List<Provider>> byCategoryId(int id) async {
    final List providersJson =
        await DbClient('getServiceProviders').get(queryParams: {
      'categoryId': id.toString(),
    });
    return providersJson
        .map((provider) => Provider.fromJson(provider))
        .toList();
  }
}

class FakeProviderService extends ProviderService {
  @override
  Future<Provider> getServiceProviderInfo(int mobileNumber) =>
      Future.value(Provider(id: 1, name: 'The Corner Stop'));

  @override
  Future<List<Provider>> byCategoryId(int id) {
    return Future.value([
      Provider(id: 1, name: 'The Corner Stop'),
      Provider(id: 2, name: 'Main Bazaar'),
      Provider(id: 3, name: 'What a Provider!'),
    ]);
  }
}
