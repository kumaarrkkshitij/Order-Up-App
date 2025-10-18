import 'package:flutter/material.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/backend/class/product_class.dart';


class CategorySalesTable extends StatelessWidget {
  final List<Sale> theList;

  const CategorySalesTable({super.key, required this.theList});

  // Map each sale product id to its corresponding name
  Future<List<DataRow>> getCategoryRows() async {

    List<DataRow> tableRows = [];
    final textStyle = TextStyle(fontSize: 14);

    Map categoryArray = {
    'snack':  [0, 0.0], // SNACKS Sales Revenue
    'drink':  [0, 0.0], // DRINKS Sales Revenue
    'dish':   [0, 0.0], // DISHES Sales Revenue
    'total':  [0, 0.0],
    };
    for (Sale sale in theList) {
      Product product = await DatabaseService().getProduct(key: sale.productId);

      categoryArray[product.category][0] += sale.quantity;
      categoryArray[product.category][1] += sale.quantity*sale.unitPrice;

      categoryArray['total'][0] += sale.quantity;
      categoryArray['total'][1] += sale.quantity*sale.unitPrice;
    }

    for (var i in categoryArray.entries) {
      tableRows.add(DataRow(
        cells: [
          DataCell(Text(i.key, style: textStyle)),
          DataCell(Text('${categoryArray[i.key][0]}', style: textStyle)),
          DataCell(Text('₱${categoryArray[i.key][1]}', style: textStyle)),
        ] 
      ));
    }

    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    // Returns the list of table rows needed from latest snapshot of products
    return FutureBuilder(future: getCategoryRows(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final salesRow = snapshot.data!;

          final textStyle = TextStyle(fontSize: 14);
          return DataTable(
            columns: [
              DataColumn(label: Text("Category", style: textStyle)),
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
