import 'dart:convert';
import 'package:event_scanner_app/data/models/saved_printer_model.dart';
import 'package:event_scanner_app/data/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

// Provider untuk Repository
final printerRepositoryProvider = Provider<PrinterRepository>(
  (ref) => PrinterRepository(ref.watch(storageServiceProvider)),
);

class PrinterRepository {
  final StorageService _storageService;

  PrinterRepository(this._storageService);

  static const String _keySavedPrinters = 'saved_printers';

  // Method untuk memeriksa apakah Bluetooth diaktifkan
  Future<bool> get isBluetoothEnabled => PrintBluetoothThermal.bluetoothEnabled;

  // Method untuk memeriksa apakah izin Bluetooth telah diberikan
  Future<bool> get isBluetoothPermissionGranted =>
      PrintBluetoothThermal.isPermissionBluetoothGranted;

  // Method untuk memeriksa apakah terhubung ke printer Bluetooth
  Future<bool> get isConnectedToPrinter =>
      PrintBluetoothThermal.connectionStatus;

  // Method untuk mendapatkan daftar printer Bluetooth yang dipasangkan
  Future<List<BluetoothInfo>> getPairedPrinters() async {
    return await PrintBluetoothThermal.pairedBluetooths;
  }

  // Method untuk koneksi ke printer Bluetooth
  Future<bool> connectToPrinter(String macAddress) async {
    return await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
  }

  // Method untuk memutuskan koneksi dari printer Bluetooth
  Future<bool> disconnectPrinter() async {
    return await PrintBluetoothThermal.disconnect;
  }

  // Method untuk mencetak teks ke printer Bluetooth
  Future<bool> printBytes(List<int> bytes) async {
    return await PrintBluetoothThermal.writeBytes(bytes);
  }

  // Method untuk mendapatkan printer yang disimpan dari storage
  List<SavedPrinterModel> getSavedPrinters() {
    final String? jsonString = _storageService.getString(_keySavedPrinters);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString); // Decode List JSON
      return decoded.map((e) => SavedPrinterModel.fromMap(e)).toList();
    } catch (e) {
      // Jika terjadi kesalahan decoding, kembalikan daftar kosong
      Logger().e('Error decoding saved printers: $e');
      return [];
    }
  }

  // Method untuk menyimpan printer ke dalam storage
  Future<void> savePrinters(
    String name,
    String macAddress,
    String template,
  ) async {
    final printers = getSavedPrinters().toList();

    // Cek apakah printer dengan macAddress yang sama sudah ada
    final existingIndex = printers.indexWhere(
      (printer) => printer.macAdress == macAddress,
    );

    if (existingIndex != -1) {
      // Jika sudah ada, perbarui informasi printer
      printers[existingIndex] = SavedPrinterModel(
        name: name,
        macAdress: macAddress,
        template: template,
      );
    } else {
      // Jika belum ada, tambahkan printer baru
      printers.add(
        SavedPrinterModel(
          name: name,
          macAdress: macAddress,
          template: template,
        ),
      );
    }

    final String jsonString = jsonEncode(
      printers.map((printer) => printer.toMap()).toList(),
    );
    _storageService.saveString(_keySavedPrinters, jsonString);
  }

  // Method untuk menghapus printer dari storage
  Future<void> deletePrinter(String macAddress) async {
    final printers = getSavedPrinters().toList();
    printers.removeWhere((printer) => printer.macAdress == macAddress);

    final String jsonString = jsonEncode(
      printers.map((printer) => printer.toMap()).toList(),
    );
    _storageService.saveString(_keySavedPrinters, jsonString);
  }
}
