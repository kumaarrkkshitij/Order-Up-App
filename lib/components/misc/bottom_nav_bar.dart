import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';

// Bottom Navigation Bar of the application
class BottomNavBar extends StatelessWidget {
  final int currentIndex;                       // Current index (item) that is last clicked on the navbar
  final ValueChanged<int> onClicked;            // Function that passes an int index to change widget when clicked on an item

  const BottomNavBar({super.key, required this.currentIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          currentIndex: currentIndex,           // Used to identify which item is selected
          selectedItemColor: AppColors.maroonColor,
          unselectedItemColor: AppColors.unselectedItem,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home), 
              label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: "Stock",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: "Camera",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              label: "Reports",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), 
              label: "Menu"
            ),
          ],
          onTap: onClicked,
          showUnselectedLabels: true,
        );
  }
}

