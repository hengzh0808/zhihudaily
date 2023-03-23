import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DailyThemeGetxCtrl.dart';
import 'DailyThemeProvider.dart';

export 'DailyThemeGetxCtrl.dart';
export 'DailyThemeProvider.dart';

enum DailyThemeMode {
  light,
  dark,
  system,
}

class DailyTheme with WidgetsBindingObserver {
  static DailyTheme? _instance;
  DailyTheme._internal();
  factory DailyTheme() {
    if (_instance == null) {
      _instance = DailyTheme._internal();
      WidgetsBinding.instance.addObserver(_instance!);
      _DailyThemeSharedPreferences.theme
          .then((theme) => _instance!.setTheme(theme));
    }
    return _instance!;
  }

  DailyThemeMode _theme = DailyThemeMode.light;
  DailyThemeMode get theme => _theme;
  Brightness get brightness {
    if (_theme == DailyThemeMode.system) {
      return window.platformBrightness;
    } else if (_theme == DailyThemeMode.dark) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  void setTheme(DailyThemeMode theme) {
    if (theme != _theme) {
      _DailyThemeSharedPreferences.setTheme(theme);
      _theme = theme;
      DailyThemeGetxCtrl().update();
      DailyThemeProvider().notifyListeners();
    }
  }

  @override
  void didChangePlatformBrightness() {
    if (_theme == DailyThemeMode.system) {
      DailyThemeGetxCtrl().update();
      DailyThemeProvider().notifyListeners();
    }
  }
}

extension _DailyThemeSharedPreferences on SharedPreferences {
  static const String _DailyThemeKey = 'DailyThemeKey';
  static const String _DailyFontScaleKey = 'DailyFontScaleKey';

  static Future<DailyThemeMode> get theme async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int index =
        preferences.getInt(_DailyThemeKey) ?? DailyThemeMode.light.index;
    if (index == 2) {
      return DailyThemeMode.system;
    } else if (index == 1) {
      return DailyThemeMode.dark;
    } else {
      return DailyThemeMode.light;
    }
  }

  static setTheme(DailyThemeMode theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_DailyThemeKey, theme.index);
  }

  static Future<double> get fontScale async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double scale = preferences.getDouble(_DailyFontScaleKey) ?? 1.0;
    return min(1.0, max(2.0, scale));
  }

  static setFontScale(double scale) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble(_DailyFontScaleKey, scale);
  }
}
