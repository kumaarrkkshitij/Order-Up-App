import 'package:flutter/material.dart';
import 'package:order_up_app/components/reports/reports_column.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPage();
}

class _ReportsPage extends State<ReportsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: WeeklyReportsColumn()
      )
    );
  }
}
