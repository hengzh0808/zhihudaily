import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DailyTheme {
  light,
  dark,
  system,
}

class DailyThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  static DailyThemeProvider? _instance;
  DailyThemeProvider._internal();
  factory DailyThemeProvider() {
    if (_instance == null) {
      _instance = DailyThemeProvider._internal();
      WidgetsBinding.instance.addObserver(_instance!);
    }
    return _instance!;
  }

  Brightness _brightness = Brightness.light;
  DailyTheme _theme = DailyTheme.light;

  Brightness get brightness => _brightness;
  DailyTheme get theme => _theme;

  void setTheme(DailyTheme theme) {
    if (theme != _theme) {
      DailyThemeSharedPreferences.setTheme(theme);
      _theme = theme;
      if (_theme == DailyTheme.system) {
        _brightness = window.platformBrightness;
      } else if (_theme == DailyTheme.dark) {
        _brightness = Brightness.dark;
      } else {
        _brightness = Brightness.light;
      }
      notifyListeners();
    }
  }

  @override
  void didChangePlatformBrightness() {
    if (_theme == DailyTheme.system) {
      if (_brightness != window.platformBrightness) {
        _brightness = window.platformBrightness;
        notifyListeners();
      }
    }
  }
}

extension DailyThemeSharedPreferences on SharedPreferences {
  static const String _DailyThemeKey = 'DailyTheme';

  static Future<DailyTheme> get theme async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int index = preferences.getInt(_DailyThemeKey) ?? DailyTheme.light.index;
    if (index == 2) {
      return DailyTheme.system;
    } else if (index == 1) {
      return DailyTheme.dark;
    } else {
      return DailyTheme.light;
    }
  }

  static setTheme(DailyTheme theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_DailyThemeKey, theme.index);
  }
}
