import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class TodayCalendar extends StatefulWidget {
  const TodayCalendar({super.key});

  @override
  State<TodayCalendar> createState() => _TodayCalendarState();
}

class _TodayCalendarState extends State<TodayCalendar> {
  final Logger log = Logger();
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    log.i("TodayCalendar initialized with date: $today");
  }

  @override
  Widget build(BuildContext context) {
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
