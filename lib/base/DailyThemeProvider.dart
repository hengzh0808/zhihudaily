import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DailyThemeProvider extends ChangeNotifier {
  Brightness _brightness = Brightness.dark;

  Brightness get brightness => _brightness;

  void setTheme(Brightness brightness) async {
    _brightness = brightness;
    notifyListeners();
  }
}
