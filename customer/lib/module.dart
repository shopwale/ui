// import 'package:injectable/injectable.dart';
// import 'package:shared/services/lib/catalog.dart';
// import 'package:shared/services/lib/category.dart';
// import 'package:shared/services/lib/customer.dart';
// import 'package:shared/services/lib/notification.dart';
// import 'package:shared/services/lib/order.dart';
// import 'package:shared/services/lib/provider.dart';

// /// Module the provides services for the Prod environment.
// @module
// class Services {
//   @injectable
//   CategoryService provideCategoryService() => FakeCategoryService();

//   @injectable
//   ProviderService provideProviderService() => ProviderService();

//   @injectable
//   CatalogService provideCatalogService() => CatalogService();

//   @injectable
//   OrderService provideOrderService() => OrderService();

//   @injectable
//   CustomerService provideCustomerService() => CustomerService();

//   @injectable
//   NotificationService provideNotificationService() => NotificationService();
// }

// /// Module the provides services for the dev environment.
// @module
// class DevServices implements Services {
//   @override
//   @injectable
//   CategoryService provideCategoryService() => FakeCategoryService();

//   @override
//   @injectable
//   ProviderService provideProviderService() => FakeProviderService();

//   @override
//   @injectable
//   CatalogService provideCatalogService() => FakeCatalogService();

//   @override
//   @injectable
//   OrderService provideOrderService() => FakeOrderService();

//   @override
//   @injectable
//   CustomerService provideCustomerService() => FakeCustomerService();

//   @injectable
//   NotificationService provideNotificationService() => FakeNotificationService();
// }
