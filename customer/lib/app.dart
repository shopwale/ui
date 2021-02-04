import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:local/widgets/lib/category_list.dart';

@provide
class LocalShopApp extends StatelessWidget {
  final CategoryListFactory _categoryListFactory;
  LocalShopApp(this._categoryListFactory);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _categoryListFactory.create(),
    );
  }
}

const appName = 'Local Shop';
