import 'main.dart' as _i1;
import 'services/lib/module.dart' as _i2;
import 'dart:async' as _i3;
import 'widgets/lib/login.dart' as _i4;
import 'services/lib/provider.dart' as _i5;
import 'services/lib/order.dart' as _i6;

class ProdInjector$Injector implements _i1.ProdInjector {
  ProdInjector$Injector._(this._devServices);

  final _i2.DevServices _devServices;

  static _i3.Future<_i1.ProdInjector> create(
      _i2.DevServices devServices) async {
    final injector = ProdInjector$Injector._(devServices);

    return injector;
  }

  _i1.VendorApp _createVendorApp() => _i1.VendorApp(_createLogin);
  _i4.Login _createLogin() => _i4.Login(_createLoginState);
  _i4.LoginState _createLoginState() =>
      _i4.LoginState(_createProviderService(), _createOrderService());
  _i5.ProviderService _createProviderService() =>
      _devServices.provideProvideService();
  _i6.OrderService _createOrderService() => _devServices.provideOrderService();
  @override
  _i1.VendorApp get app => _createVendorApp();
}
