import 'package:flutter/material.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';

class EventTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const EventTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton('My Event', 0),
          const SizedBox(width: 12),
          _buildTabButton('My Statistic', 1),
          const SizedBox(width: 12),
          _buildTabButton('Printer', 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isActive = selectedIndex == index;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.lightGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.lightGreen,
          width: 2.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabSelected(index),
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : CustomColors.lightGreen,
                fontSize: 16,
                fontFamily: 'Arial Rounded MT Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
