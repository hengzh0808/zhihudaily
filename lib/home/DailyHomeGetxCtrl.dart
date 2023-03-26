import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../base/DioBiger.dart';
import '../model/DailyDateStoriesModel.dart';

class DailyHomeGetxCtrl extends GetxController {
  var _weekDay = "".obs, _date = "".obs;
  final _dailyItems = <DailyDateStoriesModel>[].obs;
  final _controller = EasyRefreshController();
  final _logger = Logger(printer: SimplePrinter());

  String get weakDay => _weekDay.value;
  String get date => _date.value;
  List<DailyDateStoriesModel> get dailyItems => _dailyItems.value;
  List<TopStories> get topStories => _dailyItems.value.first.topStories ?? [];
  EasyRefreshController get controller => _controller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializeDateFormatting();
    _weekDay.value = DateFormat('EEEE', "zh_CN").format(DateTime.now());
    _date.value = DateFormat('M月d日', "zh_CN").format(DateTime.now());
  }

  void onReady() {
    super.onReady();
    _controller.callRefresh();
  }

  headerRefresh() async {
    try {
      final res = await _fetchItems();
      _dailyItems.value = [res];
    } catch (e) {
      Fluttertoast.showToast(msg: "刷新失败 $e");
    }
  }

  footerLoad() async {
    try {
      String date = _dailyItems.last.date ?? "";
      final res = await _fetchItems(date);
      if ((res.stories ?? []).isEmpty) {
        _controller.finishRefresh();
      } else {
        if (_controller.controlFinishLoad) {
          _controller.resetFooter();
        }
        _dailyItems.add(res);
      }
    } catch (e) {
      _logger.e(e);
      Fluttertoast.showToast(msg: "加载失败 $e");
    }
  }

  Future<DailyDateStoriesModel> _fetchItems([String? _date]) async {
    Response response;
    if (_date != null) {
      response = await dioBiger
          .get('https://news-at.zhihu.com/api/7/news/before/$_date');
    } else {
      response =
          await dioBiger.get('https://news-at.zhihu.com/api/7/stories/latest');
    }
    final res = DailyDateStoriesModel.fromJson(response.data);
    return res;
    // await Future.delayed(const Duration(milliseconds: 500));
    // String text;
    // if (_date != null) {
    //   text = await rootBundle.loadString('assets/jsons/$_date.json');
    // } else {
    //   text = await rootBundle.loadString('assets/jsons/today.json');
    // }
    // Map<String, dynamic> data = json.decode(text);
    // _logger.v(data);
    // final res = DailyDateStoriesModel.fromJson(data);
    // return res;
  }
}
