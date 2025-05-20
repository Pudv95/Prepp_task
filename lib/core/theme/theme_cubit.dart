import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeStorage storage;

  ThemeCubit(this.storage) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await storage.loadThemeMode();
    emit(theme);
  }

  Future<void> setLightTheme() async {
    await storage.saveThemeMode(ThemeMode.light);
    emit(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await storage.saveThemeMode(ThemeMode.dark);
    emit(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await storage.saveThemeMode(ThemeMode.system);
    emit(ThemeMode.system);
  }
}
