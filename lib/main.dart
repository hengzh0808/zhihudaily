import 'package:flutter/material.dart';
import 'package:zhihudaily/home/DailyHome.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
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