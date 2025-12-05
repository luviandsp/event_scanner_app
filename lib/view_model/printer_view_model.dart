import 'dart:convert';
import 'package:event_scanner_app/data/models/mock_ticket_data.dart';
import 'package:event_scanner_app/data/models/printer_state.dart';
import 'package:event_scanner_app/data/repositories/printer_repository.dart';
import 'package:event_scanner_app/data/services/storage_service.dart';
import 'package:event_scanner_app/ui/utils/printing_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterViewModel extends Notifier<PrinterState> {
  late final PrinterRepository _repository;
  static const String _savedPrintersKey = 'saved_printers';

  @override
  PrinterState build() {
    _repository = ref.read(printerRepositoryProvider);
    final savedList = _repository.getSavedPrinters();
    return PrinterState(savedDevices: savedList);
  }

  Future<void> getDevices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location, // Kadang dibutuhkan untuk discovery
    ].request();

    if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
        statuses[Permission.bluetoothConnect] != PermissionStatus.granted) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Required Bluetooth permissions are not granted. Please grant permissions.',
      );
      Logger().i(
        "Required Bluetooth permissions are not granted. Please grant permissions.",
      );
      return;
    }

    try {
      final bool isEnabled = await _repository.isBluetoothEnabled;
      if (!isEnabled) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Bluetooth is disabled. Please enable it.',
        );
        Logger().i('Bluetooth is disabled. Please enable it.');
        return;
      }

      final bool isPermissionGranted =
          await _repository.isBluetoothPermissionGranted;

      if (!isPermissionGranted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Bluetooth permission is not granted. Please grant permission.',
        );
        Logger().i(
          "Bluetooth permission is not granted. Please grant permission.",
        );
        return;
      }

      final devices = await _repository.getPairedPrinters();
      state = state.copyWith(isLoading: false, devices: devices);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to get devices: $e',
      );
    }
  }

  Future<void> connectToDevice(BluetoothInfo device) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final isCurrentPrinterConnected = state.isConnected;

      if (isCurrentPrinterConnected) {
        await _repository.disconnectPrinter();
        state = state.copyWith(isConnected: false, selectedDeviceMac: null);
      }

      final success = await _repository.connectToPrinter(device.macAdress);

      if (success) {
        await _repository.savePrinters(
          device.name,
          device.macAdress,
          'Check-in Template',
        );

        Logger().i('Connected to device: ${device.name}');

        loadSavedPrinters('');

        state = state.copyWith(
          isLoading: false,
          isConnected: true,
          selectedDeviceMac: device.macAdress,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isConnected: false,
          errorMessage: 'Failed to connect to device.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Connection error: $e',
      );
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.disconnectPrinter();
      state = state.copyWith(
        isLoading: false,
        isConnected: false,
        selectedDeviceMac: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Disconnection error: $e',
      );
    }
  }

  void loadSavedPrinters(String query) {
    final savedDevices = _repository.getSavedPrinters();
    if (query.trim().isEmpty) {
      state = state.copyWith(savedDevices: savedDevices);
    } else {
      final filtered = savedDevices
          .where(
            (printer) =>
                printer.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      state = state.copyWith(savedDevices: filtered);
    }
  }

  Future<void> deletePrinter(String macAddress) async {
    try {
      final updatedSavedDevices = state.savedDevices
          .where((printer) => printer.macAdress != macAddress)
          .toList();

      final String jsonString = jsonEncode(
        updatedSavedDevices.map((printer) => printer.toMap()).toList(),
      );

      final storageService = ref.read(storageServiceProvider);
      storageService.saveString(_savedPrintersKey, jsonString);

      await _repository.disconnectPrinter();
      Logger().i('Printer deleted successfully: $macAddress');

      state = state.copyWith(savedDevices: updatedSavedDevices);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete printer: $e');
    }
  }

  Future<void> savePrinterTemplate(
    String name,
    String macAddress,
    String template,
  ) async {
    await _repository.savePrinters(name, macAddress, template);
    loadSavedPrinters('');
  }

  Future<void> printCheckInStruk() async {
    if (!state.isConnected) return;

    state = state.copyWith(isLoading: true);

    // CONTOH DATA (Ambil dari form input Anda nanti)
    final ticket = MockTicketData(
      ticketName: "VIP Konser Musik 2024",
      paymentType: "Tiket Berbayar",
      price: 150000,
      category: "VIP A",
      description: "Include Free Drink & Merchandise",
      bookingId: "INV-20231025-001",
      checkInTime: DateTime.now(),
    );

    try {
      // 1. Generate Bytes
      final bytes = await generateCheckInReceipt(ticket);

      // 2. Kirim ke Printer
      await _repository.printBytes(bytes);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Gagal print: $e");
    }
  }
}

final printerViewModelProvider =
    NotifierProvider<PrinterViewModel, PrinterState>(() => PrinterViewModel());
