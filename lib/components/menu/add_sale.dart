import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/backend/class/product_class.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';

class AddSale extends StatefulWidget {
  final Product product;

  const AddSale({
    super.key,
    required this.product
  });

  @override
  State<AddSale> createState() => _AddSale();
}

class _AddSale extends State<AddSale> {
  int addSaleQuantity = 0;
  Color clickableButtonColor = AppColors.scarletColor;
  Color unclickableButtonColor = AppColors.unselectedItem;


  Map<String, bool> toggleQuantityButton = {
    "minus": false,
    "plus": true,
  };


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(color: AppColors.greyContainer, borderRadius: BorderRadius.circular(16)),
                child: widget.product.productImgUrl != "" ? Image.network(
                  widget.product.productImgUrl,
                  height: 120,
                  width: 120,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('img/orderuplogo.png', fit: BoxFit.cover);
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ) : Image.asset('img/orderuplogo.png', width: 120, height: 120,)
              ),

              Text(widget.product.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              Text("₱${widget.product.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              Text.rich(
                TextSpan(
                  // with no TextStyle it will have default text style
                  text: 'Stock: ',
                  children: <TextSpan>[
                    TextSpan(text: widget.product.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                  style: TextStyle(fontSize: 24)
                ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle, 
                        color: toggleQuantityButton["minus"]! ? clickableButtonColor : unclickableButtonColor 
                      ),
                      onPressed: () {
                        setState(() {
                          if (addSaleQuantity > 0) {
                            if (addSaleQuantity == 1) {
                              toggleQuantityButton["minus"] = false;
                            } else {
                              toggleQuantityButton["minus"] = true;
                            }
                            addSaleQuantity--;
                            toggleQuantityButton["plus"] = true;
                          }
                      
                        });
                      },
                    ),
                    Text("$addSaleQuantity",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: toggleQuantityButton["plus"]! ? clickableButtonColor : unclickableButtonColor 
                      ),
                      onPressed: () {
                        setState(() {
                          if (widget.product.quantity!=addSaleQuantity) {
                            if (widget.product.quantity-1 == addSaleQuantity) {
                              toggleQuantityButton["plus"] = false;
                            } else {
                              toggleQuantityButton["plus"] = true;
                            }
                            addSaleQuantity++;
                            toggleQuantityButton["minus"] = true;

                          }
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: clickableButtonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      DatabaseService().addNewSale(id: widget.product.productId, quantityToDeduct: addSaleQuantity, unitPrice: widget.product.price);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add Sale",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),

            ],
          )
        )
      )
    );
  }
}