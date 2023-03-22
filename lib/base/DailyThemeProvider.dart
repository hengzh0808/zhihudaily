import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyThemeProvider extends ChangeNotifier {
  factory DailyThemeProvider() => _instance;

  DailyThemeProvider._internal();
  static late final DailyThemeProvider _instance = DailyThemeProvider._internal();

  static Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;

  void setTheme(Brightness brightness) {
    if (DailyThemeProvider._brightness != brightness) {
      DailyThemeSharedPreferences.setBrightness(brightness);
      _brightness = brightness;
      notifyListeners();
    }
  }
}

extension DailyThemeSharedPreferences on SharedPreferences {
  static String _themeKey = 'DailyTheme';

  static Future<Brightness> get brightness async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int index = preferences.getInt(_themeKey) ?? Brightness.light.index;
    if (index < Brightness.values.length && index >= 0) {
      return Brightness.values[index];
    }
    return Brightness.light;
  }

  static setBrightness(Brightness brightness) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_themeKey, brightness.index);
  }
}
