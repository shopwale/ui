import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:local/app.dart';
import 'module.dart';
import 'main.inject.dart' as g;

void main() async {
  final injector = await ProdInjector.create(new Services());
  runApp(injector.app);
}

@Injector(const [Services])
abstract class ProdInjector {
  @provide
  LocalShopApp get app;

  static final create = g.ProdInjector$Injector.create;
}
