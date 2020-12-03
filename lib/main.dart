import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:vendor/module.dart';
import 'package:vendor/app.dart';
import 'main.inject.dart' as g;

void main() async {
  final injector = await ProdInjector.create(new Services());
  runApp(injector.app);
}

@Injector(const [Services])
abstract class ProdInjector {
  @provide
  VendorApp get app;

  static final create = g.ProdInjector$Injector.create;
}
