import 'package:inject/inject.dart';
import 'package:shared/services/lib/catalog.dart';
import 'package:shared/services/lib/category.dart';
import 'package:shared/services/lib/customer.dart';
import 'package:shared/services/lib/notification.dart';
import 'package:shared/services/lib/order.dart';
import 'package:shared/services/lib/provider.dart';

/// Module the provides services for the Prod environment.
@module
class Services {
  @provide
  CategoryService provideCategoryService() => FakeCategoryService();

  @provide
  ProviderService provideProviderService() => ProviderService();

  @provide
  CatalogService provideCatalogService() => CatalogService();

  @provide
  OrderService provideOrderService() => OrderService();

  @provide
  CustomerService provideCustomerService() => CustomerService();

  @provide
  NotificationService provideNotificationService() => NotificationService();
}

/// Module the provides services for the dev environment.
@module
class DevServices implements Services {
  @override
  @provide
  CategoryService provideCategoryService() => FakeCategoryService();

  @override
  @provide
  ProviderService provideProviderService() => FakeProviderService();

  @override
  @provide
  CatalogService provideCatalogService() => FakeCatalogService();

  @override
  @provide
  OrderService provideOrderService() => FakeOrderService();

  @override
  @provide
  CustomerService provideCustomerService() => FakeCustomerService();

  @provide
  NotificationService provideNotificationService() => FakeNotificationService();
}
