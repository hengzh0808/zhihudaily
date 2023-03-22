import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/DailyHome.dart';
import '../base/DailyThemeProvider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());

  DailyThemeSharedPreferences.brightness.then((brightness) {
    DailyThemeProvider().setTheme(brightness);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zhihudaily',
      home: const DailyHome(),
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        fontFamily: 'MiSans',
      ),
    );
  }
}
