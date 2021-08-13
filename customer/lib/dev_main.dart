import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:local/app.dart';
import 'module.dart';
import 'dev_main.inject.dart' as g;

void main() async {
  final injector = await DevInjector.create(new DevServices());
  runApp(injector.app);
}

@Injector(const [DevServices])
abstract class DevInjector {
  @injectable
  LocalShopApp get app;

  static final create = g.DevInjector$Injector.create;
}
