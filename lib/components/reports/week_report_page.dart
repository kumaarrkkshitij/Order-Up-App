import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/components/reports/sales_table.dart';
import 'package:order_up_app/components/reports/category_sales_table.dart';
import 'package:order_up_app/components/reports/best_seller_table.dart';


class WeekReportPage extends StatelessWidget {
  final List<Sale> theList;
  final DateTime startDateWeek;

  const WeekReportPage({super.key, required this.theList, required this.startDateWeek});
  @override
  Widget build(BuildContext context) {
    final DateTime endDateWeek = startDateWeek.add(Duration(days: 6));
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.maroonColor, foregroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              "Weekly Report  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32
              )
            ),
            Text(
              "(${startDateWeek.month}/${startDateWeek.day}/${startDateWeek.year}-${endDateWeek.month}/${endDateWeek.day}/${endDateWeek.year})",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              )
            ),
            TableContainer(headerText: 'Category Sales Breakdown', table: CategorySalesTable(theList: theList)),
            TableContainer(headerText: 'Best Sellers', table: BestSellerTable(theList: theList)),
            TableContainer(headerText: 'All Week Sales', table: SalesTable(theList: theList))
          ],
        )
      )
    );
  }
}

class TableContainer extends StatelessWidget {
  final String headerText;
  final Widget table;

  const TableContainer({super.key, required this.headerText, required this.table});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)   
      ),
      child: Column(
        children: [
          Text(
            headerText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: table
          )
        ],
      )
    );
  }
}