import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/DailyHome.dart';
import '../detail/DailyStoryDetail.dart';
import '../setting/DailySetting.dart';

class DailyRoutes {
  static const home = '/';
  static const details = '/details';
  static const setting = '/setting';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DailyRoutes.home:
        return GetPageRoute(
          settings: settings,
          page: () => const DailyHome(),
        );
      case DailyRoutes.details:
        final args = settings.arguments as Map<String, dynamic>;
        final id = args['id'];
        return GetPageRoute(
          settings: settings,
          page: () => DailyStoryDetail(
            id: id,
          ),
        );
      case DailyRoutes.setting:
        return GetPageRoute(
          settings: settings,
          page: () => DailySetting(),
        );
      default:
        Get.defaultDialog(content: Text('不支持的路由跳转 ${settings.name ?? ''}'));
        return null;
    }
  }
}
