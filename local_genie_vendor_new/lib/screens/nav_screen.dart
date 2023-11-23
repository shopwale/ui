import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/screens/home/home_screen.dart';
import 'package:local_genie_vendor/screens/settings/settings_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages(BuildContext context) {
    return <Widget>[
      const HomeScreen(),
      // const CartsScreenNew(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages(context),
      ), //New
      bottomNavigationBar: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          // final cartsCount = ref.watch(cartsProvider).length;
          return BottomNavigationBar(
            backgroundColor: darkBlue,
            selectedItemColor: PrimarySwatch,
            unselectedItemColor: lightGrey,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            iconSize: 28,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 0 ? Icons.home : Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 2
                    ? Icons.settings
                    : Icons.settings_outlined),
                label: 'Setting',
              ),
            ],

            currentIndex: _selectedIndex, //New
            onTap: (int index) async {
              // final secureStorage = SecureStorage();
              // var cookie = await secureStorage.readSecureData(cookieKey);
              // if (cookie.isEmpty && index != 0) {
              //   Navigator.of(context).pushNamed("/login");
              //   return;
              // }
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  //New
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
