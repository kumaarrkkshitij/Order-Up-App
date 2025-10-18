import 'package:flutter/material.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/components/misc/app_colors.dart';

const List<String> categories = ['Snack', "Drink", "Dish"];

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  String categoryPseudoController = categories.first;
  String nameErrorMsg = "";
  String priceErrorMsg = "";
  String barcodeErrorMsg = "";
  TextStyle errorStyle = TextStyle(color: AppColors.scarletColor);

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  onClickedAddProduct() async {
    bool validInputs = true;
    String disallowedChars = "@#{};\'\"";
    final disallowedRegex = RegExp('[' + RegExp.escape(disallowedChars) + ']');

    setState(() {
      if (disallowedRegex.hasMatch(productNameController.text)) {
        validInputs = false;
        nameErrorMsg = "Product has disallowed characters: @#{};\'\"";
      } else if (productNameController.text == "") {
        validInputs = false;
        nameErrorMsg = "Product name should not be empty";
      } else {
        nameErrorMsg = "";
      }

      try {
        if (double.parse(priceController.text) <= 0) {
          validInputs = false;
          priceErrorMsg = "Product price should be more than 0.";
        } else {
          priceErrorMsg = "";
        }
      } catch (e) {
        validInputs = false;
        priceErrorMsg = "Product price is not valid.";
      }
      

      if (!RegExp(r'^[0-9]+$').hasMatch(barcodeController.text) && barcodeController.text != "") {
        validInputs = false;
        barcodeErrorMsg = "Barcode should have numbers only.";
      } else {
        barcodeErrorMsg = "";
      }
    });

    // Please add validation soon.
    if (validInputs) {
      await DatabaseService().addProduct(
        name: productNameController.text, 
        price: double.parse(priceController.text), 
        quantity: 0,
        category: categoryPseudoController.toLowerCase(), 
        imageUrl: imageController.text,
        barcodeNo: barcodeController.text
      );

      snackBar('Product successfully added.');
      Navigator.pop(context);
    }
    
  }

  void changedCategory(String? newValue) {
    setState(() {
      categoryPseudoController = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {

     return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add New Product",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Name
              const Text(
                "Product Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 5),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Text(nameErrorMsg, style: errorStyle),
              const SizedBox(height: 15),

              // Price
              const Text(
                "Price",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    '₱',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(priceErrorMsg, style: errorStyle),
              const SizedBox(height: 15),

              // Image Link
              const Text(
                "Image Link (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: imageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Category
              const Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: categoryPseudoController,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryPseudoController = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Barcode Number
              const Text(
                "Barcode No. (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                keyboardType: TextInputType.number,
                controller: barcodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Text(barcodeErrorMsg, style: errorStyle),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClickedAddProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.scarletColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}