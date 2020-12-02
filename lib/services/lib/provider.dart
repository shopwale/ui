import 'package:shared/models/lib/provider.dart';
import 'db.dart';

class ProviderService {
  Future<Provider> getServiceProviderInfo(int mobileNumber) async {
    // http://localshopwala.com:3001/getServiceProviderInfo?serviceProviderMobile=989898934
    final dbClient = DbClient('getServiceProviderInfo', serverPort: 3001);
    final jsonResponse = await dbClient
        .get(queryParams: {'serviceProviderMobile': mobileNumber.toString()});

    return Provider.fromJson(jsonResponse);
  }
}

class FakeProviderService extends ProviderService {
  @override
  Future<Provider> getServiceProviderInfo(int mobileNumber) =>
      Future.value(Provider(id: 1, name: 'The Corner Stop'));
}
