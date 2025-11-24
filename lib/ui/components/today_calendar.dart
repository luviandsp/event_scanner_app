import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayCalendar extends StatelessWidget {
  const TodayCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Row(
      children: [
        Icon(Icons.calendar_month, color: CustomColors.darkGreen, size: 30),
        SizedBox(width: 10),
        Text(
          DateFormat('dd MMM yyyy').format(today),
          style: TextStyle(
            color: CustomColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
