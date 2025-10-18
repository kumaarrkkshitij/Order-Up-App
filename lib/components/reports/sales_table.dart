import 'package:flutter/material.dart';
import 'package:order_up_app/backend/class/sale_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/backend/class/product_class.dart';


class SalesTable extends StatelessWidget {
  final List<Sale> theList;

  const SalesTable({super.key, required this.theList});

  // Map each sale product id to its corresponding name
  Future<List<DataRow>> getSaleRows() async {
    List<DataRow> saleRows = [];
    final textStyle = TextStyle(fontSize: 14);

    for (Sale sale in theList) {
      Product product = await DatabaseService().getProduct(key: sale.productId);
      saleRows.add(DataRow(
        cells: [
          DataCell(Text(product.productName, style: textStyle)),
          DataCell(Text('${sale.dateTime.month}/${sale.dateTime.day}/${sale.dateTime.year} ${sale.dateTime.hour}:${sale.dateTime.minute}:${sale.dateTime.second.toString().padLeft(2, '0')}', style: textStyle)),
          DataCell(Text('${sale.quantity}', style: textStyle)),
          DataCell(Text('₱${sale.unitPrice}', style: textStyle)),
          DataCell(Text('₱${sale.unitPrice*sale.quantity}', style: textStyle)),
        ] 
      ));
    }

    return saleRows;
  }

  @override
  Widget build(BuildContext context) {
    // Returns the list of table rows needed from latest snapshot of products
    return FutureBuilder(future: getSaleRows(), builder: (context, snapshot) {
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
              DataColumn(label: Text("Date", style: textStyle)),
              DataColumn(label: Text("Quantity", style: textStyle)),
              DataColumn(label: Text("Unit Price", style: textStyle)),
              DataColumn(label: Text("Total Price", style: textStyle)),
            ], 

            // Latest sale is on first row if reversed
            rows: salesRow.reversed.toList(),
            columnSpacing: 20,
          );
        }
    });
  }
}
