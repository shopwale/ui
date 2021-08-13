// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:local/app.dart';
import 'package:shared/services/catalog.dart';

import 'package:shared/services/category.dart';
import 'package:shared/services/customer.dart';
import 'package:shared/services/order.dart';
import 'package:shared/services/provider.dart';
import 'package:local/widgets/lib/catalog.dart';
import 'package:local/widgets/lib/category_card.dart';
import 'package:local/widgets/lib/category_list.dart';
import 'package:local/widgets/lib/checkout.dart';
import 'package:local/widgets/lib/provider_card.dart';
import 'package:local/widgets/lib/provider_list.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      LocalShopApp(
        CategoryListFactory(
          FakeCategoryService(),
          CategoryCardFactory(
            FakeProviderService(),
            ProviderListFactory(
              ProviderCardFactory(
                FakeCatalogService(),
                CatalogFactory(
                  CheckoutFactory(
                    FakeOrderService(),
                    FakeCustomerService(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // TODO(mikefrenil): Add validations.
  });
}
