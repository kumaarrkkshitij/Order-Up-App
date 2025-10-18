import 'package:flutter/material.dart';
import 'package:order_up_app/components/menu/menu_table.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text('Snacks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            MenuTable(category: 'snack'),

            Text('Drinks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            MenuTable(category: 'drink'),
            
            Text('Dishes', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            MenuTable(category: 'dish')
          ],
        )
      )
    );
  }
}