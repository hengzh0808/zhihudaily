import 'package:flutter/material.dart';
import 'DailyTheme.dart';

class DailyThemeProvider extends ChangeNotifier {
  DailyThemeProvider._internal();
  
  factory DailyThemeProvider() => _instance;
  
  static late final DailyThemeProvider _instance = DailyThemeProvider._internal();

  DailyThemeMode get theme => DailyTheme().theme;
  Brightness get brightness => DailyTheme().brightness;
}

