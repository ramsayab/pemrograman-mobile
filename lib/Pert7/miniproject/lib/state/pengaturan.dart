import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  double target = 1000000;
  Color seedColor = const Color(0xff126782);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getBool('dark_mode') == true
        ? ThemeMode.dark
        : ThemeMode.light;
    target = prefs.getDouble('target') ?? target;
    seedColor = Color(prefs.getInt('seed_color') ?? seedColor.toARGB32());
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool('dark_mode', themeMode == ThemeMode.dark),
    );
    notifyListeners();
  }

  Future<void> saveTarget(double value) async {
    target = value;
    (await SharedPreferences.getInstance()).setDouble('target', value);
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    seedColor = color;
    (await SharedPreferences.getInstance()).setInt(
      'seed_color',
      color.toARGB32(),
    );
    notifyListeners();
  }
}
