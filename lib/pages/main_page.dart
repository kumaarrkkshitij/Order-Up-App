import 'package:flutter/material.dart';
import 'package:order_up_app/backend/firebase/auth_service.dart';
import 'package:order_up_app/pages/burger/about_page.dart';
import 'package:order_up_app/pages/burger/account_page.dart';
import 'package:order_up_app/pages/navbar_items/home_page.dart';
import 'package:order_up_app/pages/navbar_items/stock_page.dart';
import 'package:order_up_app/pages/navbar_items/reports_page.dart';
import 'package:order_up_app/pages/navbar_items/menu_page.dart';
import 'package:order_up_app/components/misc/bottom_nav_bar.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/components/camera/barcode_scanner.dart';

// This widget is the first thing a user should see after logging in
class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPage();
}

class _AppMainPage extends State<AppMainPage> {

  // -------- NAV BAR INDICES -------- //
  int _selectedNavBarIndex = 0; // Index of the Page on the Bottom Navbar (First page to be shown is always Home page)

  // Invoked when user clicks on a navbar item
  void _onClicked(int index) {
    setState(() {
      _selectedNavBarIndex = index;
    });
  }

  // Used to identify which text to display on the app bar
  final Map<int, String> _appbarText = {
    0: "Home",
    1: "Stock",
    2: "Camera",
    3: "Reports",
    4: "Menu",
  };

  // Used to identify which widget or page to go to when user clicks on an navbar item
  final List<Widget> _navBarPages = [
      HomePage(),               // 0
      StockPage(),              // 1
      BarcodeScanner(),         // 2
      ReportsPage(),            // 3
      MenuPage(),               // 4
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService, 
      builder: (context, authService, child) {
        return StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          return Scaffold(
            // App Bar
            appBar: AppBar(
              backgroundColor: AppColors.maroonColor, 
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('img/orderuplogo.png', scale: 16,),
                  Text(
                  _appbarText[_selectedNavBarIndex]!,
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.headerColor),
                  ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: 'Account', child: Text('Account')),
                      PopupMenuItem<String>(value: 'About', child: Text('About')),
                      PopupMenuItem<String>(value: 'Log out', child: Text('Log out')),
                    ],
                    onSelected: (value) async {
                      if (value=='About') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      } else if (value=='Account') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const AccountPage(),
                          ),
                        );
                      } else if (value=='Log out') {
                        try {
                          await authService.signOut();
                        } catch (e) {
                          return;
                        }
                      } 
                    },
                    icon: Icon(Icons.menu, color: AppColors.pitchColor),
                  )
                ],
              )
            ),

            // Pages you can visit from the navbar
            body: _navBarPages[_selectedNavBarIndex],

            // Navbar (Home, Stock, Reports, Menu)
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.maroonColor, width: 2))
              ),
              child: BottomNavBar(
                currentIndex: _selectedNavBarIndex, 
                onClicked: (int index) {_onClicked(index);}
              )
            )
          );
        }
      );
      }
    );
  }
}
