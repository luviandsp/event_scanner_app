import 'dart:async';
import 'package:event_scanner_app/ui/components/auto_print_switch.dart';
import 'package:event_scanner_app/ui/components/printer_card.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  final Logger logger = Logger();
  bool isAutoPrintOn = true;

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Timer? _debounce;

  List<Map<String, dynamic>> printers = [
    {
      'name': 'Epson L-300 Series',
      'status': 'Available',
      'is_available': true,
      'current_template': 'Check Struct',
    },
    {
      'name': 'Brother HL-L2350DW',
      'status': 'Not Available',
      'is_available': false,
      'current_template': 'Name Badge',
    },
    {
      'name': 'HP LaserJet Pro M15w',
      'status': 'Available',
      'is_available': true,
      'current_template': 'Event Ticket',
    },
    {
      'name': 'Canon Pixma G2010',
      'status': 'Available',
      'is_available': true,
      'current_template': 'Check Struct',
    },
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      logger.i('Searching for printers with query: $query');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoPrintSwitch(
          value: isAutoPrintOn,
          onChanged: (newValue) {
            setState(() {
              isAutoPrintOn = newValue;
              logger.i('Auto Print is now: $isAutoPrintOn');
            });
          },
        ),

        const SizedBox(height: 20),

        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Available Printers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 10),

        Form(
          key: _formKey,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Printers',
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: CustomColors.lightGreen),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: printers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            return PrinterCard(printer: printers[index]);
          },
        ),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.darkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Agar tombol tidak lebar full
              children: const [
                Text(
                  'Add Printer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.add, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
