// providers/preferences_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';


final monthlyBudgetProvider = StateNotifierProvider<BudgetNotifier, double>((ref) => BudgetNotifier());

class BudgetNotifier extends StateNotifier<double> {
  BudgetNotifier() : super(0.0) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('monthly_budget') ?? 0.0;
  }

  Future<void> setBudget(double amount) async {
    state = amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthly_budget', amount);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode') ?? 'system';
    state = ThemeMode.values.firstWhere((e) => e.name == mode, orElse: () => ThemeMode.system);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('app_language') ?? 'en';
    state = Locale(code);
  }

  Future<void> setLanguage(String code) async {
    state = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', code);
  }
}