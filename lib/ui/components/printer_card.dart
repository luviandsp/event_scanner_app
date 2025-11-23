import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class PrinterCard extends StatefulWidget {
  final Map<String, dynamic> printer;
  const PrinterCard({super.key, required this.printer});

  @override
  State<PrinterCard> createState() => _PrinterCardState();
}

class _PrinterCardState extends State<PrinterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.print, size: 60, color: CustomColors.darkGreen),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.printer['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.darkGreen,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.printer['status'],
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.printer['is_available'] == true
                        ? CustomColors.darkGreen
                        : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Current Template:",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          widget.printer['current_template'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: CustomColors.darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.yellow,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        child: const Text(
                          'Configure',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
