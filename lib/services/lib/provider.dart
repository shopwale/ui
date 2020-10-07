import 'package:vendor/models/lib/provider.dart';

abstract class ProviderService {
  Future<Provider> getServiceProviderInfo(int mobileNumber);
}

class FakeProviderService extends ProviderService {
  @override
  Future<Provider> getServiceProviderInfo(int mobileNumber) =>
      Future.value(Provider(id: 1, name: 'The Corner Stop'));
}
