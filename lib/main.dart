import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:vendor/services/lib/module.dart';
import 'package:vendor/types/lib/inject.dart';
import 'package:vendor/widgets/lib/login.dart';
import 'main.inject.dart' as g;

void main() async {
  final injector = await ProdInjector.create(new DevServices());
  runApp(injector.app);
}

@Injector(const [DevServices])
abstract class ProdInjector {
  @provide
  VendorApp get app;

  static final create = g.ProdInjector$Injector.create;
}

@provide
class VendorApp extends StatelessWidget {
  final Provider<Login> loginWidgetProvider;

  const VendorApp(this.loginWidgetProvider);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Shop Vendor',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: loginWidgetProvider(),
    );
  }
}
