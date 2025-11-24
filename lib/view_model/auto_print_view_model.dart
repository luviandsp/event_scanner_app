import 'package:event_scanner_app/data/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoPrintViewModel extends Notifier<bool> {
  static const String _autoPrintKey = 'auto_print_enabled';

  @override
  bool build() {
    final storageService = ref.watch(storageServiceProvider);
    return storageService.getBool(_autoPrintKey, defaultValue: true);
  }

  void setAutoPrint(bool value) {
    state = value;
    ref.read(storageServiceProvider).saveBool(_autoPrintKey, value);
  }
}

final autoPrintProvider = NotifierProvider<AutoPrintViewModel, bool>(
  () => AutoPrintViewModel(),
);