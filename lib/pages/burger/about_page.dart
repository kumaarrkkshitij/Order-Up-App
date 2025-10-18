import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.maroonColor, foregroundColor: AppColors.whiteColor,
      ),
      body: Center(
        child: SizedBox(
          width: 412,
          height: 917,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OrderUp!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Img1 //
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset("img/about1.PNG", fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 16),

                      // Img2 //
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset("img/about2.PNG", fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 24),

                      // About card //
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What is the app all about?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "This app will serve as a stock management and order menu system for the business. It will allow staff to track inventory levels in real time while also providing a streamlined digital menu for processing customer orders. This ensures efficient operations, accurate stock control, and faster service.",
                              style: TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nav Bar //
             
            ],
          ),
        ),
      ),
    );
  }
}
