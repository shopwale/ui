import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vendor/app.dart';
import 'package:shared/services/catalog.dart';
import 'package:shared/services/customer.dart';
import 'package:shared/services/notification.dart';
import 'package:shared/services/order.dart';
import 'package:shared/services/provider.dart';

import 'main.config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();
  runApp(VendorApp());
}

final _getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(_getIt, environment: prod.name);

@module
abstract class ProdServices {
  @prod
  ProviderService provideProvideService() => ProviderService();

  @prod
  OrderService provideOrderService() => OrderService();

  @prod
  CatalogService provideCatalogService() => CatalogService();

  @prod
  CustomerService provideCustomerService() => CustomerService();

  @prod
  NotificationService provideNotificationService() => NotificationService();
}
