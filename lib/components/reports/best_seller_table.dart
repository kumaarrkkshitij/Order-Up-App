import 'package:flutter/material.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/backend/class/product_class.dart';


class BestSellerTable extends StatelessWidget {
  final List<Sale> theList;

  const BestSellerTable({super.key, required this.theList});

  // Map each sale product id to its corresponding name
  Future<List<DataRow>> getProductRows() async {

    List<DataRow> tableRows = [];
    final textStyle = TextStyle(fontSize: 14);

    Map<String, Map<String, dynamic>> productMap = {};
    for (Sale sale in theList) {
      Product product = await DatabaseService().getProduct(key: sale.productId);

      productMap[sale.productId] = {}; 
      productMap[sale.productId] = {
        'productName': product.productName,
        'sales': productMap[sale.productId]!['sales'] ?? 0 + sale.quantity,
        'revenue': productMap[sale.productId]!['revenue'] ?? 0.0 + sale.quantity*sale.unitPrice
      };
    }

    // Sorts by revenue
    final sortedEntries = productMap.entries.toList()
    ..sort((a, b) => a.value['sales'].compareTo(b.value['sales']));
    final sortedData = Map.fromEntries(sortedEntries.reversed);

    for (var i in sortedData.entries) {
      tableRows.add(DataRow(
        cells: [
          DataCell(Text(i.value['productName'], style: textStyle)),
          DataCell(Text('${i.value['sales']}', style: textStyle)),
          DataCell(Text('₱${i.value['revenue']}', style: textStyle)),
        ] 
      ));
    }

    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    // Returns the list of table rows needed from latest snapshot of products
    return FutureBuilder(future: getProductRows(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final salesRow = snapshot.data!;

          final textStyle = TextStyle(fontSize: 14);
          return DataTable(
            columns: [
              DataColumn(label: Text("Product", style: textStyle)),
              DataColumn(label: Text("Sales", style: textStyle)),
              DataColumn(label: Text("Revenue", style: textStyle)),
            ], 

            rows: salesRow,
            columnSpacing: 100,
          );
        }
    });
  }
}
