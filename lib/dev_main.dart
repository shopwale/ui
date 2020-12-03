import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:vendor/module.dart';
import 'package:vendor/app.dart';
import 'dev_main.inject.dart' as g;

void main() async {
  final injector = await DevInjector.create(new DevServices());
  runApp(injector.app);
}

@Injector(const [DevServices])
abstract class DevInjector {
  @provide
  VendorApp get app;

  static final create = g.DevInjector$Injector.create;
}
