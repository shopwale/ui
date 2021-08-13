import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:local/app.dart';
import 'module.dart';
import 'main.inject.dart' as g;

void main() async {
  final injector = await ProdInjector.create(new Services());
  runApp(injector.app);
}

@Injector(const [Services])
abstract class ProdInjector {
  @injectable
  LocalShopApp get app;

  static final create = g.ProdInjector$Injector.create;
}
