import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/envirnoment.dart';
import 'package:local_genie_vendor/models/order_modal.dart';
import 'package:local_genie_vendor/screens/auth/login_sreen.dart';
import 'package:local_genie_vendor/screens/nav_screen.dart';
import 'package:local_genie_vendor/screens/orders/order_details_screen.dart';
import 'package:local_genie_vendor/screens/settings/profile_screen.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: Environment.fileName);
  } catch (e) {
    print("object");
    print(e.toString());
  }
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loacl Genie Vendor',
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.white,
        primarySwatch: PrimarySwatch,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.green.withOpacity(.3),
          cursorColor: Colors.green.withOpacity(.6),
          selectionHandleColor: Colors.white.withOpacity(1),
        ),
        fontFamily: "Montserrat",
      ),
      color: Colors.blueAccent.shade700,
      initialRoute: "/",
      routes: {
        '/': (context) => NavScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/order_details': (context) {
          var args = OrderDetailsArgumentsI.fromJson(ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>);
          return OrderDetailsScreen(orderId: args.orderId);
        },
      },
    );
  }
}
