import 'package:equatable/equatable.dart';
import 'package:event_scanner_app/data/models/saved_printer_model.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterState extends Equatable {
  final List<BluetoothInfo> devices;
  final bool isConnected;
  final bool isLoading;
  final String? selectedDeviceMac;
  final String? errorMessage;
  final List<SavedPrinterModel> savedDevices;

  const PrinterState({
    this.devices = const [],
    this.isConnected = false,
    this.isLoading = false,
    this.selectedDeviceMac,
    this.errorMessage,
    this.savedDevices = const [],
  });

  PrinterState copyWith({
    List<BluetoothInfo>? devices,
    bool? isConnected,
    bool? isLoading,
    String? selectedDeviceMac,
    String? errorMessage,
    List<SavedPrinterModel>? savedDevices,
  }) {
    return PrinterState(
      devices: devices ?? this.devices,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      selectedDeviceMac: selectedDeviceMac ?? this.selectedDeviceMac,
      errorMessage: errorMessage ?? this.errorMessage,
      savedDevices: savedDevices ?? this.savedDevices,
    );
  }

  @override
  List<Object?> get props => [
    devices,
    isConnected,
    isLoading,
    selectedDeviceMac,
    errorMessage,
    savedDevices,
  ];
}
