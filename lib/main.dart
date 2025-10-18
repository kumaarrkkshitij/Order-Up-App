import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';
import 'components/misc/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initializes binding before running Firebase
  try {
    await Firebase.initializeApp(); // Initializes Firebase
    runApp(
      // Runs app normally if connection is successfully made
      const MyApp(connected: true),
    );
  } catch (e) {
    runApp(MyApp(connected: false, error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  final bool connected;
  final String? error;
  const MyApp({super.key, required this.connected, this.error});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => LoginPage()}, // Goes to Login page
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.pitchColor,
        canvasColor: AppColors.navBarColor
      )
    );
  }
}