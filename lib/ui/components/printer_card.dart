import 'package:event_scanner_app/data/models/saved_printer_model.dart';
import 'package:event_scanner_app/ui/components/template_printer_config_dialog.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/view_model/printer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

enum PrinterMenuOption { testPrint, disconnect, delete }

class PrinterCard extends ConsumerStatefulWidget {
  final SavedPrinterModel printer;

  const PrinterCard({super.key, required this.printer});

  @override
  ConsumerState<PrinterCard> createState() => _PrinterCardState();
}

class _PrinterCardState extends ConsumerState<PrinterCard> {
  @override
  Widget build(BuildContext context) {
    final printerViewModelState = ref.watch(printerViewModelProvider);
    final printerViewModel = ref.read(printerViewModelProvider.notifier);

    final isCurrentPrinterConnected =
        printerViewModelState.isConnected &&
        printerViewModelState.selectedDeviceMac == widget.printer.macAdress;

    return GestureDetector(
      onTap: () {
        if (isCurrentPrinterConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Printer is already connected.")),
          );
          return;
        }

        printerViewModel.connectToDevice(
          BluetoothInfo(
            name: widget.printer.name,
            macAdress: widget.printer.macAdress,
          ),
        );
      },
      child: Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.printer.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.darkGreen,
                        ),
                      ),

                      SizedBox(
                        height: 24,
                        width: 24,
                        child: PopupMenuButton<PrinterMenuOption>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (PrinterMenuOption result) {
                            switch (result) {
                              case PrinterMenuOption.testPrint:
                                printerViewModel.printCheckInStruk();
                                break;

                              case PrinterMenuOption.disconnect:
                                printerViewModel.disconnect();
                                break;

                              case PrinterMenuOption.delete:
                                printerViewModel.deletePrinter(
                                  widget.printer.macAdress,
                                );
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<PrinterMenuOption>>[
                                const PopupMenuItem<PrinterMenuOption>(
                                  value: PrinterMenuOption.testPrint,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: Colors.black54,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Test Print'),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem<PrinterMenuOption>(
                                  value: PrinterMenuOption.disconnect,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.bluetooth_disabled_outlined,
                                        color: Colors.black54,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Disconnect'),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem<PrinterMenuOption>(
                                  value: PrinterMenuOption.delete,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.black54,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    printerViewModelState.isConnected &&
                            printerViewModelState.selectedDeviceMac ==
                                widget.printer.macAdress
                        ? 'Status: Connected'
                        : 'Status: Not Connected',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          widget.printer.macAdress ==
                              printerViewModelState.selectedDeviceMac
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            widget.printer.template,
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return TemplatePrinterConfigDialog(
                                  printerName: widget.printer.name,
                                  currentTemplate: widget.printer.template,
                                  onConfirm: (newTemplate) {
                                    printerViewModel.savePrinterTemplate(
                                      widget.printer.name,
                                      widget.printer.macAdress,
                                      newTemplate,
                                    );
                                    Logger().i(
                                      'Printer "${widget.printer.name}" template changed to "$newTemplate"',
                                    );
                                  },
                                );
                              },
                            );
                          },
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
      ),
    );
  }
}
