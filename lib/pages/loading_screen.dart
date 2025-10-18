import 'package:flutter/material.dart';

// This has yet to have any actual use or appearance
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive(),)  
    );
  }
}