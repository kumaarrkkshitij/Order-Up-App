import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/components/menu/add_sale.dart';
import 'package:order_up_app/backend/class/product_class.dart';


class MenuTable extends StatelessWidget {
  // Used to determine what products will be shown on this table by category
  final String category;

  const MenuTable({super.key, required this.category});
  
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

        final List<Container> productRows = [];

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
              Container(
                width: 350, height: 50,
                margin: EdgeInsets.only(top: 2, bottom: 2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.greyContainer),
                child: ListTile(

                  // Shows the actual image if product has a valid image link, shows app logo if otherwise
                  leading: currentProduct.productImgUrl.toString() != "" ? 
                  Image.network(
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('img/orderuplogo.png', fit: BoxFit.cover);
                    },
                    currentProduct.productImgUrl.toString(),

                    width: 40, height: 40
                  ) : Image.asset('img/orderuplogo.png'),

                  // Product name
                  title: Text(
                    currentProduct.productName, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17
                      ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    ),

                  // Opens Add Sale widget when clicked on corresponding to product
                  onTap: () => showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AddSale(product: currentProduct);
                    }
                  ),
                )
              )
            );
          }
        }
        return Container(
          width: 370, 
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: Center(
            child: Column(
              children: productRows
            ),
          )
        );
      },
    );
  }
}