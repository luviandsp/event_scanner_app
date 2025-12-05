import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/view_model/printer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothDeviceCard extends ConsumerStatefulWidget {
  final BluetoothInfo device;
  const BluetoothDeviceCard({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<BluetoothDeviceCard> createState() => _PrinterCardState();
}

class _PrinterCardState extends ConsumerState<BluetoothDeviceCard> {
  @override
  Widget build(BuildContext context) {
    final printerViewModelState = ref.watch(printerViewModelProvider);
    final printerViewModel = ref.read(printerViewModelProvider.notifier);

    final isCurrentPrinterConnected =
        printerViewModelState.isConnected &&
        printerViewModelState.selectedDeviceMac == widget.device.macAdress;

    return GestureDetector(
      onTap: () {
        if (isCurrentPrinterConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Printer is already connected.")),
          );
          return;
        }

        printerViewModel.connectToDevice(widget.device);
        Navigator.pop(context);
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
            const Icon(Icons.devices, size: 40, color: CustomColors.darkGreen),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.device.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.darkGreen,
                    ),
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
