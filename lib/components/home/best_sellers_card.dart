import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/backend/class/product_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';


class BestSellerCard extends StatefulWidget {
  const BestSellerCard({super.key});

  @override
  State<BestSellerCard> createState() => _BestSellerCard();
}

class _BestSellerCard extends State<BestSellerCard> {

  // Returns sales from today
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

  // Gets top three products sold today by quantity
  getTopThree() async {
    Map map = await getSales();
    List entries = map.entries.toList();

    // Sort descending by quantity
    entries.sort((a, b) => (b.value['quantity'] as num).compareTo(a.value['quantity'] as num));

    List topThreeList = entries.take(3).toList();

    return topThreeList;
  }

  // Gets list of containers with top three products
  Future<List<Container>> getBestContainers() async {
    List<Container> containers = [];
    List topThree = await getTopThree();

    for (var top in topThree) {
      Product product = await DatabaseService().getProduct(key: top.key);
      containers.add(
        Container(
          width: 100, height: 180, margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.pitchColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), 
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 0), 
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80, height: 80, margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: AppColors.greyContainer,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Image.network(product.productImgUrl, width: 64)
              ),
              Text(product.productName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${top.value['quantity']} sold today')
            ],
          ),
        )
      );
    }

    return containers;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref("sales").onValue,
      builder: (context, snapshot) {
        return FutureBuilder<List<Widget>>(
          future: getBestContainers(),
          builder: (context, containerSnapshot) {
            if (containerSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (containerSnapshot.hasError) {
              return Text('Error: ${containerSnapshot.error}');
            }

            return Center(
              child: Container(
                width: 350, height: 200,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (containerSnapshot.data == null || containerSnapshot.data!.isEmpty) ? [Text("No sales today.")] : containerSnapshot.data!,
                ),
                
              )
            );
          },
        );
      }
    );
  }
}