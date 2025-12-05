import 'dart:async';
import 'package:event_scanner_app/data/models/printer_state.dart';
import 'package:event_scanner_app/ui/components/add_bluetooth_devices_dialog.dart';
import 'package:event_scanner_app/ui/components/auto_print_switch.dart';
import 'package:event_scanner_app/ui/components/printer_card.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/view_model/auto_print_view_model.dart';
import 'package:event_scanner_app/view_model/printer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PrinterPage extends ConsumerStatefulWidget {
  const PrinterPage({super.key});

  @override
  ConsumerState<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends ConsumerState<PrinterPage> {
  final Logger logger = Logger();

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(printerViewModelProvider.notifier).loadSavedPrinters(query);
      logger.i('Searching for printers with query: $query');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAutoPrintOn = ref.watch(autoPrintProvider);
    final printerViewModelState = ref.watch(printerViewModelProvider);
    final printerViewModel = ref.read(printerViewModelProvider.notifier);

    ref.listen<PrinterState>(printerViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          AutoPrintSwitch(
            value: isAutoPrintOn,
            onChanged: (newValue) {
              ref.read(autoPrintProvider.notifier).setAutoPrint(newValue);
              logger.i('Auto Print toggled to: $newValue');
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
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: CustomColors.lightGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: CustomColors.darkGreen,
                    width: 2,
                  ),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          printerViewModelState.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                )
              : printerViewModelState.savedDevices.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Text(
                    'No saved printers found. Please add a printer.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: printerViewModelState.savedDevices.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return PrinterCard(
                      printer: printerViewModelState.savedDevices[index],
                    );
                  },
                ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddBluetoothDevicesDialog();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
