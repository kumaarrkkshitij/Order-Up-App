class Product {
  String productId = "";
  String productName = "";
  String productImgUrl = "";
  String category = "";
  int quantity = 0;
  double price = 0.0;
  String? barcode;

  Product({
    required this.productId, 
    required this.productName, 
    required this.category, 
    required this.productImgUrl, 
    required this.quantity, 
    required this.price,
    this.barcode
  });
}