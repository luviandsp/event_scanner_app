import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrinterListState {
  final List<Map<String, dynamic>> allPrinters;
  final List<Map<String, dynamic>> filteredPrinters;

  PrinterListState({required this.allPrinters, required this.filteredPrinters});
}

class PrinterListViewModel extends Notifier<PrinterListState> {
  final _initialData = [
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
  PrinterListState build() {
    return PrinterListState(
      allPrinters: _initialData,
      filteredPrinters: _initialData,
    );
  }

  // Fungsi Search Printer
  void searchPrinter(String query) {
    if (query.isEmpty) {
      state = PrinterListState(
        allPrinters: state.allPrinters,
        filteredPrinters: state.allPrinters,
      );
    } else {
      final filtered = state.allPrinters.where((printer) {
        final name = printer['name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      state = PrinterListState(
        allPrinters: state.allPrinters,
        filteredPrinters: filtered,
      );
    }
  }
}

final printerListProvider =
    NotifierProvider<PrinterListViewModel, PrinterListState>(
      () => PrinterListViewModel(),
    );
