import 'package:inject/inject.dart';

import 'catalog.dart';
import 'customer.dart';
import 'notification.dart';
import 'order.dart';
import 'provider.dart';

@module
class Services {
  @provide
  ProviderService provideProvideService() => ProviderService();

  @provide
  OrderService provideOrderService() => OrderService();

  @provide
  CatalogService provideCatalogService() => CatalogService();

  @provide
  CustomerService provideCustomerService() => CustomerService();

  @provide
  NotificationService provideNotificationService() => NotificationService();
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

  @provide
  CustomerService provideCustomerService() => FakeCustomerService();

  @provide
  NotificationService provideNotificationService() => FakeNotificationService();
}
