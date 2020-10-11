import 'package:inject/inject.dart';
import 'package:vendor/services/lib/catalog.dart';
import 'package:vendor/services/lib/order.dart';
import 'package:vendor/services/lib/provider.dart';

@module
class Services {
  @provide
  ProviderService provideProvideService() {
    throw UnimplementedError();
  }

  @provide
  OrderService provideOrderService() {
    throw UnimplementedError();
  }

  @provide
  CatalogService provideCatalogService() => CatalogService();
}

@module
class DevServices implements Services {
  @override
  @provide
  ProviderService provideProvideService() => FakeProviderService();

  @override
  @provide
  OrderService provideOrderService() => FakeOrderService();

  @override
  @provide
  CatalogService provideCatalogService() => FakeCatalogService();
}
