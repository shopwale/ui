import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vendor/app.dart';
import 'package:shared/services/lib/catalog.dart';
import 'package:shared/services/lib/customer.dart';
import 'package:shared/services/lib/notification.dart';
import 'package:shared/services/lib/order.dart';
import 'package:shared/services/lib/provider.dart';

import 'main.config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();
  runApp(VendorApp());
}

final _getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(_getIt);

@module
abstract class Services {
  ProviderService provideProvideService() => ProviderService();

  OrderService provideOrderService() => OrderService();

  CatalogService provideCatalogService() => CatalogService();

  CustomerService provideCustomerService() => CustomerService();

  NotificationService provideNotificationService() => NotificationService();
}
