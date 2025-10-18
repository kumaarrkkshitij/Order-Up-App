import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/backend/class/product_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';

class DailyDashboard extends StatefulWidget {
  const DailyDashboard({super.key});

  @override
  State<DailyDashboard> createState() => _DailyDashboard();
}

class _DailyDashboard extends State<DailyDashboard> {

  // Gets sales from today
  Future<Map<String, Map>> getSales() async {

    List salesList = await DatabaseService().getFirstSale();
    Map<String, Map<String, dynamic>> salesToday = {};
    
    DateTime timeNow = DateTime.now();
    for (Sale sale in salesList) {
      DateTime currentSaleDate = sale.dateTime;
      if (
        currentSaleDate.year==timeNow.year &&
        currentSaleDate.month==timeNow.month &&
        currentSaleDate.day==timeNow.day
      ) {

        salesToday[sale.productId] ??= {
          'quantity': 0,
          'revenue': 0,
        };

        salesToday[sale.productId]!['quantity'] = (salesToday[sale.productId]!['quantity'] ?? 0) + sale.quantity;
        salesToday[sale.productId]!['revenue'] = (salesToday[sale.productId]!['revenue'] ?? 0) + (sale.unitPrice * sale.quantity);
      }

    }
    
    return salesToday;
  }

  // Method that returns either total 'quantity' or 'revenue' for today
  Future<double> getAttributeToday(String attribute) async {
    try {
      Map map = await getSales();
      double counter = 0;
      for (var i in map.values) {
        counter += i[attribute];
      }
      return counter;
    } catch (e) {
      return 0;
    }
  }

  // Returns the product with highest 'quantity' or 'revenue' for today
  Future<MapEntry> getTopAttribute(String attribute) async {
    Map map = await getSales();
    List entries = map.entries.toList();

    entries.sort((a, b) => (b.value[attribute] as num).compareTo(a.value[attribute] as num));

    List topProduct = entries.take(1).toList();
    if (topProduct.isNotEmpty) {
      return topProduct[0];
    } else {
      return MapEntry("null", {
        "quantity": 0,
        "revenue": 0
      });
    }
  }

  Future<Container> containerContent() async {
    MapEntry topRevenue = await getTopAttribute('revenue');
    MapEntry topQuantity = await getTopAttribute('quantity');

    Product topRevenueProduct; Product topQuantityProduct;
    if (topRevenue.key=="null" || topQuantity.key=="null") {
      topRevenueProduct = Product(productId: 'null', productName: 'N/A', category: 'snack', productImgUrl: '', quantity: 0, price: 0);
      topQuantityProduct = Product(productId: 'null', productName: 'N/A', category: 'snack', productImgUrl: '', quantity: 0, price: 0);
    } else {
      topRevenueProduct = await DatabaseService().getProduct(key: topRevenue.key);
      topQuantityProduct = await DatabaseService().getProduct(key: topQuantity.key);
    }

    int salesMadeToday = (await getAttributeToday('quantity')).toInt();
    double revenueMadeToday = await getAttributeToday('revenue');

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), 
            color: AppColors.maroonColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3), 
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 0), 
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• Most Revenue: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "${topRevenueProduct.productName} (₱${topRevenue.value['revenue']})"),
                  ],
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• Most Sales: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "${topQuantityProduct.productName} (${topQuantity.value['quantity']})"),
                  ],
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• No. of Sales Today: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "$salesMadeToday"),
                  ],
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '• Revenue Today: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '₱$revenueMadeToday'),
                  ],
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref("sales").onValue,
      builder: (context, snapshot) {
        return FutureBuilder<Container>(
          future: containerContent(),
          builder: (context, containerSnapshot) {
            if (containerSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (containerSnapshot.hasError) {
              return Text('Error: ${containerSnapshot.error}');
            }

            return Center(
              child: Container(
                width: 350, height: 224,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: containerSnapshot.data
              )
            );
          },
        );
      }
    );
  }
}