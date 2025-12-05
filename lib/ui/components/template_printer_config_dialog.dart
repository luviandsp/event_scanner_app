import 'dart:ui';

import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class TemplatePrinterConfigDialog extends StatefulWidget {
  final String printerName;
  final String currentTemplate;
  final Function(String newTemplate) onConfirm;

  const TemplatePrinterConfigDialog({
    super.key,
    required this.printerName,
    required this.currentTemplate,
    required this.onConfirm,
  });

  @override
  State<TemplatePrinterConfigDialog> createState() =>
      _TemplatePrinterConfigDialogState();
}

class _TemplatePrinterConfigDialogState
    extends State<TemplatePrinterConfigDialog> {
  final List<String> _templates = ['Name Badge', 'Check-In Struct', 'Voucher'];
  late String _selectedTemplate;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.currentTemplate;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Configure Printer Template',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.darkGreen,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.print,
                      size: 50,
                      color: CustomColors.darkGreen,
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.printerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: CustomColors.darkGreen,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Current Template:",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),

                          Text(
                            _selectedTemplate,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Column(
                children: _isExpanded
                    ? _templates
                          .map((template) => _buildOptionButton(template))
                          .toList()
                    : [
                        _buildOptionButton(
                          _selectedTemplate,
                          isDropdownTrigger: true,
                        ),
                      ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  // Back Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F), // Merah
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),

                      child: const Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onConfirm(_selectedTemplate);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.lightGreen, // Teal/Tosca
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),

                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildOptionButton(String text, {bool isDropdownTrigger = false}) {
    bool isSelected = text == _selectedTemplate;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isDropdownTrigger) {
            // Jika diklik saat mode collapse, maka expand
            _isExpanded = !_isExpanded;
          } else {
            // Jika diklik saat mode expand, pilih item & collapse
            _selectedTemplate = text;
            _isExpanded = false;
          }
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 5,
        ), // Jarak antar item saat expand
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected && !_isExpanded ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: CustomColors.darkGreen, width: 1.5),
          boxShadow: isDropdownTrigger && !_isExpanded
              ? [] // Flat saat collapse
              : [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),

        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: CustomColors.darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
