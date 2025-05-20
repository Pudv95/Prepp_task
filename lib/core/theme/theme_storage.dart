import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeStorage {
  static const _key = 'theme_mode';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _storage.write(key: _key, value: mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final value = await _storage.read(key: _key);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
