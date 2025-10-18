class Sale {
  String saleId = "";
  String productId = "";
  DateTime dateTime;
  int quantity = 0;
  double unitPrice = 0.0;

  Sale({
    required this.saleId, 
    required this.productId,
    required this.dateTime, 
    required this.quantity, 
    required this.unitPrice,
  });
}