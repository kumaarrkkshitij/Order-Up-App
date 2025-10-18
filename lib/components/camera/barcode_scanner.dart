import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/components/menu/add_sale.dart';
import 'package:order_up_app/backend/class/product_class.dart';
import 'package:order_up_app/components/misc/app_colors.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScanner();
}

class _BarcodeScanner extends State<BarcodeScanner> {
  // Used to avoid multiple instances of Add Sale dialog stacked on each other
  bool barcodePicked = false; 

  // Checks if camera detected barcode matches a barcode entry in each product
  detectedBarcode(String? result, AsyncSnapshot<DatabaseEvent> snapshot) {
    final data = snapshot.data!.snapshot.value as Map<Object?, Object?>;
    for (var product in data.entries) {
      final productRow = product.value as Map<Object?, Object?>;

      if (result==productRow['barcode_num']) {
        return product.key.toString();
      }
    }
    return "null";
  }

  final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size(640,480),
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 250,
    formats: [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA],
    returnImage: false,
    torchEnabled: false,
    invertImage: false,
    autoZoom: false,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref("products").onValue,      // the current data of the products database
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {    // Waits before the database has been loaded
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {                                      // error
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return Stack(
          children: [

            // The scanner instance
            MobileScanner(
              controller: controller,
              onDetect: (result) async {
                if (!barcodePicked) {
                  barcodePicked = true;

                  String matchedKey = detectedBarcode(result.barcodes.first.rawValue, snapshot);
                  Product product = await DatabaseService().getProduct(key: matchedKey);
                  
                  if (!context.mounted) return;
                  if (matchedKey == "null") {
                    showDialog(context: context, builder: (context) {return Scaffold(body:Text("Nothing."));});
                  } else {
                    await showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AddSale(product: product);
                      }
                    );
                    
                  }
                  barcodePicked = false;
                }
              },
            ),

            // Dark opaque overlay
            CustomPaint(
                size: MediaQuery.of(context).size,
                painter: ScannerOverlay(),
              ),

            // Label Text
            SizedBox(
              height: 110,
              child: Center(
                  child: Text(
                  "Scan Product Barcode",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pitchColor
                  )
                ),
              )
            )
            
          ],
        );
      }
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromRGBO(0, 0, 0, 0.6);

    final background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const double cutOutWidth = 640;
    const double cutOutHeight = 480;

    double left = (size.width - cutOutWidth) / 2;
    double top = (size.height - cutOutHeight) / 2;

    final cutOut = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, cutOutWidth, cutOutHeight),
        const Radius.circular(12),
      ));

    final overlay = Path.combine(PathOperation.difference, background, cutOut);
    canvas.drawPath(overlay, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, cutOutWidth, cutOutHeight),
        const Radius.circular(12),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}