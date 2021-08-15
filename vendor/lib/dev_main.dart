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

import 'dev_main.config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();
  runApp(VendorApp());
}

final _getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initDevGetIt')
void configureDependencies() => $initDevGetIt(_getIt, environment: dev.name);

@module
abstract class DevServices {
  @dev
  ProviderService provideProvideService() => FakeProviderService();

  @dev
  OrderService provideOrderService() => FakeOrderService();

  @dev
  CatalogService provideCatalogService() => FakeCatalogService();

  @dev
  CustomerService provideCustomerService() => FakeCustomerService();

  @dev
  NotificationService provideNotificationService() => FakeNotificationService();
}
