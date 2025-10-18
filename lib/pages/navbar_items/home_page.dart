import 'package:flutter/material.dart';
import '../../backend/firebase/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_up_app/components/home/best_sellers_card.dart';
import 'package:order_up_app/components/home/daily_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getUsername(uid: (FirebaseAuth.instance.currentUser?.uid)!), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12, top: 12),
                  height: 64,
                  child: Text(
                    "Hello, ${snapshot.data}!",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                SizedBox(height:10),
                Center(
                  child: Text('Best Sellers', 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)
                  )
                ),
                SizedBox(height:10),
                BestSellerCard(),
                SizedBox(height:30),
                Center(
                  child: Text('Daily Dashboard', 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)
                  )
                ),
                SizedBox(height:10),
                DailyDashboard()
              ],
            )
          )
        );
      }
    );
  }
}