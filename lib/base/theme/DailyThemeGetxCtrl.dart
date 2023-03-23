import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'DailyTheme.dart';

class DailyThemeGetxCtrl extends GetxController {
  DailyThemeGetxCtrl._internal();

  factory DailyThemeGetxCtrl() => _instance;

  static late final DailyThemeGetxCtrl _instance =
      DailyThemeGetxCtrl._internal();

  DailyThemeMode get theme => DailyTheme().theme;
  Brightness get brightness => DailyTheme().brightness;
}
