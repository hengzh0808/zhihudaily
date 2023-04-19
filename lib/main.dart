import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../base/DailyRoutes.dart';
import '../base/theme/DailyTheme.dart';

void main() {
  debugPaintSizeEnabled = true;
  // WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zhihudaily',
      initialRoute: DailyRoutes.home,
      onGenerateRoute: (setting) => DailyRoutes.onGenerateRoute(setting),
      navigatorKey: Get.key,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        fontFamily: 'MiSans',
      ),
    );
  }
}
