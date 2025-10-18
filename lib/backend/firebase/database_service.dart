import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/backend/class/product_class.dart';
import 'package:order_up_app/backend/class/sale_class.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  // CRU Basic Methods
  Future<void> create({
    required String path, // oath of the file
    required Map<String, dynamic> data // data to write
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.set(data);
  }

  Future<DataSnapshot?> read({required String path}) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  Future<void> update({
    required String path,
    required Map<String, dynamic> data
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.update(data);
  }

  Future<String> getUsername({required String uid}) async {
    DataSnapshot? userSnapshot = await DatabaseService().read(path: "users/$uid/name");

    String userName = userSnapshot!.value.toString();
    return userName;
  }

  // -------------------------- UPDATE PRODUCT DETAILS ------------------------------- //
  Future<void> updateName({required String id, required String name}) {
    update(path: "products/$id", data: {"name": name});
    return Future.value();
  }

  Future<void> updateImage({required String id, required String imageLink}) {
    update(path: "products/$id", data: {"image_url": imageLink});
    return Future.value();
  }

  Future<void> updateProductPrice({required String id, required double price}) {
    update(path: "products/$id", data: {"price": price});
    return Future.value();
  }

  Future<void> updateBarcode({required String id, required String barcode}) {
    update(path: "products/$id", data: {"barcode_num": barcode});
    return Future.value();
  }

  Future<void> updateCategory({required String id, required String category}) {
    update(path: "products/$id", data: {"category": category});
    return Future.value();
  }

  // ----------------------- ADD METHODS ------------------------------- //
  Future<void> addNewSale({required String id, required int quantityToDeduct, required unitPrice}) async {
    DatabaseReference salesRef = _firebaseDatabase.ref("sales");
    Product product = await getProduct(key: id);

    update(path: "products/$id", data: {"quantity": product.quantity-quantityToDeduct});
    salesRef.push().set({
      'product_id': id,
      'quantity'  : quantityToDeduct,
      'timestamp'  : ServerValue.timestamp,
      'unitPrice'  : unitPrice,
    });
  }

  Future<void> addStock({required String id, required int quantityToAdd}) async {
    Product product = await getProduct(key: id);

    update(path: "products/$id", data: {"quantity": product.quantity+quantityToAdd});
  }

  Future<void> addProduct({
    required String name,
    required double price,
    required int quantity,
    required String category,
    required String imageUrl,
    required String barcodeNo
    }) async {
    DatabaseReference ref = _firebaseDatabase.ref("products");
    
    ref.push().set({
      'name'      : name,
      'price'     : price,
      'quantity'  : quantity,
      'category'  : category,
      'image_url' : imageUrl,
      'barcode_num' : barcodeNo
    });
  }

  // ---------------------------- READ METHODS ------------------------------ //

  Future<Product> getProduct({required String key}) async {
    DataSnapshot? productSnapshot = await DatabaseService().read(path: "products/${key}");
    Map<Object?, Object?> productMap = productSnapshot!.value as Map<Object?, Object?>;

    return Product(
      productId: key, 
      productName: productMap['name'].toString(), 
      productImgUrl: productMap['image_url'].toString(), 
      quantity: int.parse(productMap['quantity'].toString()), 
      price: double.parse(productMap['price'].toString()),
      barcode: productMap['barcode_num'].toString(),
      category: productMap['category'].toString()
    );
  }

  Future<List<Sale>> getFirstSale() async {
    DataSnapshot? salesSnapshot = await DatabaseService().read(path: "sales");
    Map<Object?, Object?> salesMap = salesSnapshot!.value as Map<Object?, Object?>;

    // int unixMs = 1759430400000; 
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(unixMs);

    // DateTime firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));

    
    List<Sale> salesList = [];
    for (var sale in salesMap.entries) {

      final saleValue = sale.value as Map?;
      salesList.add(Sale(
        saleId: sale.key.toString(),
        productId: (saleValue?['product_id'].toString())!,
        quantity: int.parse((saleValue?['quantity'].toString())!),
        dateTime: DateTime.fromMillisecondsSinceEpoch(int.parse((saleValue?['timestamp'].toString())!)),
        unitPrice: double.parse((saleValue?['unitPrice'].toString())!)
      ));
    }


    return salesList;
  }
}