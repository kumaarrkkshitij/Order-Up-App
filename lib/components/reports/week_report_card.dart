import 'package:flutter/material.dart';
import 'package:order_up_app/components/misc/app_colors.dart';
import 'package:order_up_app/components/reports/week_report_page.dart';
import 'package:order_up_app/backend/class/sale_class.dart';

class WeekReportCard extends StatefulWidget {
  final List<Sale> theList;
  final DateTime startDateWeek;

  const WeekReportCard({super.key, required this.theList, required this.startDateWeek});

  @override
  State<WeekReportCard> createState() => _WeekReportCard();
}

class _WeekReportCard extends State<WeekReportCard> {

  @override
  Widget build(BuildContext context) {

    Map months = {
      '1': "Jan",
      '2': "Feb",
      '3': "Mar",
      '4': "Apr",
      '5': "May",
      '6': "Jun",
      '7': "Jul",
      '8': "Aug",
      '9': "Sep",
      '10': "Oct",
      '11': "Nov",
      '12': "Dec",
    };

    DateTime endRange = widget.startDateWeek.add(Duration(days: 6));
    String startDate = "${months[widget.startDateWeek.month.toString()]} ${widget.startDateWeek.day.toString()} ${widget.startDateWeek.year}";
    String endDate = "${months[endRange.month.toString()]} ${endRange.day.toString()} ${endRange.year}";

    return InkWell(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => 
        WeekReportPage(
          theList: widget.theList, 
          startDateWeek: widget.startDateWeek)
        )
      );
    },
      child: Container(
        width: 380,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(borderRadius:BorderRadius.circular(8), color: Colors.white),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('img/reports_card_bg.png', width: 350),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withValues(alpha: 0.6), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('Week Report', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('[$startDate - $endDate]', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                ]
              ),
            )

          ],
        )
      ),
      );
  }
}