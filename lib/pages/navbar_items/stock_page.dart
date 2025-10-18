import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/components/stock/stock_table.dart';
import 'package:order_up_app/components/stock/add_product.dart';
import 'package:order_up_app/components/stock/search_bar.dart';


class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPage();
}

class _StockPage extends State<StockPage> {

  Container tableHeaderContainer(String headerText) {
    TextStyle tableHeaderStyle = TextStyle(

    );

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Text(headerText, style: tableHeaderStyle), 
          FloatingActionButton.small(
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {return AddProduct();});
            }, 
            backgroundColor: AppColors.maroonColor2, 
            child: Icon(Icons.add, 
            color: AppColors.headerColor)
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 25),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              StockSearchBar(),
              FloatingActionButton.small(
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context) {return AddProduct();});
                }, 
                backgroundColor: AppColors.maroonColor2, 
                child: Icon(Icons.add, 
                color: AppColors.headerColor)
              )
            ],),
            ),
            
            Text('Snacks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            StockTable(category: 'snack'),

            Text('Drinks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            StockTable(category: 'drink'),
            
            Text('Dishes', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            StockTable(category: 'dish')
          ],
        )
      )
    );
  }
}
