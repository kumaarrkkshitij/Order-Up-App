import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/components/stock/edit_product.dart';
import 'package:order_up_app/backend/class/product_class.dart';


class StockTable extends StatelessWidget {
  final String category;

  const StockTable({super.key, required this.category});
  
  @override
  Widget build(BuildContext context) {
    // StreamBuilder is used to update the table everytime data is changed in realtime
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref("products").onValue,      // the current data of the products database
      builder: (context, snapshot) {                                  // the actual widget where the data is to be placed in
        if (snapshot.connectionState == ConnectionState.waiting) {    // loading indicator while waiting
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {                                      // error
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {                                      // No products in table
          return Center(child: Text("No products available"));
        }

        // Raw json data from products database
        final data = snapshot.data!.snapshot.value as Map<Object?, Object?>;

        final List<DataRow> productRows = [];

        // Loops through each product in the table to add each attribute data into a DataRow
        for (var product in data.entries) {
          final productRow = product.value as Map<Object?, Object?>;

          if (productRow['category'].toString()==category) {
            Product currentProduct =  Product(
              productId: product.key.toString(),
              productImgUrl: productRow['image_url'].toString(),
              productName: productRow['name'].toString(),
              quantity: int.parse(productRow['quantity'].toString()),
              price: double.parse(productRow['price'].toString()),
              category: productRow['category'].toString(),
              barcode: productRow['barcode_num'].toString()
            );

            
            productRows.add(
              DataRow(cells: [
                DataCell(Text(
                    productRow['name'].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )
                ),
                DataCell(Text(productRow['price'].toString())),
                DataCell(Text(productRow['quantity'].toString(), style: TextStyle(color: productRow['quantity']==0 ? Colors.red : Colors.black),))
              ],
              onSelectChanged: (value) => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                  EditProduct(product: currentProduct)
                ))

                // showDialog(
                //   context: context, 
                //   builder: (BuildContext context) {
                //     return EditProduct(product: currentProduct);
                //   }
                // )
              },
            ),
            );
          }
        }
        return Container(
          margin: EdgeInsets.all(16), padding: EdgeInsets.all(12),
          width: 500,
          decoration: BoxDecoration(
            color: AppColors.whiteColor, 
            borderRadius: BorderRadius.circular(10)
          ),

          // Stock Table
          child: DataTable(
            columns: [
              DataColumn(label: Text('PRODUCT')),
              DataColumn(label: Text("PRICE")),
              DataColumn(label: Text("QUANTITY"))
            ],
            rows: productRows,
            showCheckboxColumn: false,
          )
        );
      },
    );
  }
}