import 'dart:ui';
import 'package:event_scanner_app/ui/components/bluetooth_device_card.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/view_model/printer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AddBluetoothDevicesDialog extends ConsumerStatefulWidget {
  const AddBluetoothDevicesDialog({super.key});

  @override
  ConsumerState<AddBluetoothDevicesDialog> createState() =>
      _AddBluetoothDevicesDialogState();
}

class _AddBluetoothDevicesDialogState
    extends ConsumerState<AddBluetoothDevicesDialog> {
  @override
  Widget build(BuildContext context) {
    final printerViewModelState = ref.watch(printerViewModelProvider);
    final printerViewModel = ref.read(printerViewModelProvider.notifier);

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
                    'Add Bluetooth Devices',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.darkGreen,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              printerViewModelState.isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    )
                  : printerViewModelState.devices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Text(
                        'No paired printers found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: printerViewModelState.devices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return BluetoothDeviceCard(
                          device: printerViewModelState.devices[index],
                        );
                      },
                    ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  printerViewModel.getDevices();
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
                      'Scan Devices',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.refresh, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
