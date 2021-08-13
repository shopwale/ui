// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared/services/catalog.dart' as _i3;
import 'package:shared/services/customer.dart' as _i5;
import 'package:shared/services/notification.dart' as _i7;
import 'package:shared/services/order.dart' as _i9;
import 'package:shared/services/provider.dart' as _i10;

import 'app.dart' as _i11;
import 'main.dart' as _i12;
import 'widgets/current_orders.dart' as _i4;
import 'widgets/login.dart' as _i6;
import 'widgets/order_details.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final services = _$Services();
  gh.factory<_i3.CatalogService>(() => services.provideCatalogService());
  gh.factory<_i4.CurrentOrdersFactory>(() => _i4.CurrentOrdersFactory());
  gh.factory<_i5.CustomerService>(() => services.provideCustomerService());
  gh.factory<_i6.Login>(() => _i6.Login());
  gh.factory<_i7.NotificationService>(
      () => services.provideNotificationService());
  gh.factory<_i8.OrderDetailsFactory>(() => _i8.OrderDetailsFactory());
  gh.factory<_i9.OrderService>(() => services.provideOrderService());
  gh.factory<_i10.ProviderService>(() => services.provideProvideService());
  gh.factory<_i11.VendorApp>(() => _i11.VendorApp());
  gh.factory<_i4.CurrentOrdersState>(() => _i4.CurrentOrdersState(
      get<_i9.OrderService>(),
      get<_i8.OrderDetailsFactory>(),
      get<_i5.CustomerService>()));
  gh.factory<_i6.LoginState>(() => _i6.LoginState(
      get<_i10.ProviderService>(),
      get<_i9.OrderService>(),
      get<_i4.CurrentOrdersFactory>(),
      get<_i3.CatalogService>(),
      get<_i7.NotificationService>()));
  gh.factory<_i8.OrderDetailsState>(() => _i8.OrderDetailsState(
      get<_i9.OrderService>(), get<_i5.CustomerService>()));
  return get;
}

class _$Services extends _i12.Services {}
