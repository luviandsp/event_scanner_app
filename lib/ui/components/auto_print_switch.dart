import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class AutoPrintSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AutoPrintSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<AutoPrintSwitch> createState() => _AutoPrintSwitchState();
}

class _AutoPrintSwitchState extends State<AutoPrintSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CustomColors.lightGreen, width: 2),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Auto Print',
            style: TextStyle(
              color: CustomColors.lightGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: () {
              widget.onChanged(!widget.value);
            },
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: CustomColors.veryLightGreen,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: CustomColors.lightGreen, width: 2),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: widget.value
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: 60,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomColors.lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'ON',
                            style: TextStyle(
                              color: widget.value
                                  ? Colors.white
                                  : CustomColors.lightGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'OFF',
                            style: TextStyle(
                              color: !widget.value
                                  ? Colors.white
                                  : CustomColors.lightGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
