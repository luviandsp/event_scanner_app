import 'package:mmkv/mmkv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  late final MMKV _mmkv;

  StorageService() {
    _mmkv = MMKV.defaultMMKV();
  }

  void saveString(String key, String value) {
    _mmkv.encodeString(key, value);
  }

  String? getString(String key) {
    return _mmkv.decodeString(key);
  }

  void saveBool(String key, bool value) {
    _mmkv.encodeBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _mmkv.decodeBool(key, defaultValue: defaultValue);
  }

  void remove(String key) {
    _mmkv.removeValue(key);
  }
}

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);
