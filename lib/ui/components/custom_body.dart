import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/ui/components/today_calendar.dart';
import 'package:event_scanner_app/ui/pages/analysis_report_pages/statistic_page.dart';
import 'package:event_scanner_app/ui/pages/event_ticket_pages/event_page.dart';
import 'package:event_scanner_app/ui/pages/printer_pages/printer_page.dart';
import 'package:flutter/material.dart';

class CustomBody extends StatefulWidget {
  const CustomBody({super.key});

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),

        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),

          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 25),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: TodayCalendar(),
              ),

              const SizedBox(height: 20),

              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTabButton('My Event', 0),
                      _buildTabButton('My Statistic', 1),
                      _buildTabButton('Printer', 2),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildSelectedContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return EventPage(); // Tampilan Event
      case 1:
        return StatisticPage(); // Tampilan Statistik
      case 2:
        return PrinterPage(); // Tampilan Printer
      default:
        return EventPage(); // Default ke Tampilan Event
    }
  }

  Widget _buildTabButton(String text, int index) {
    bool isActive = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? CustomColors.lightGreen : Colors.white,
          foregroundColor: isActive ? Colors.white : CustomColors.lightGreen,
          elevation: 0,
          minimumSize: const Size(100, 40),
          side: BorderSide(color: CustomColors.lightGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),

        child: Text(text),
      ),
    );
  }
}
