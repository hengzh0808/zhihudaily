import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart' hide Response;

import '../base/DioBiger.dart';
import '../home/DailyHomeBanner.dart';
import '../Model/DailyDateStoriesModel.dart';
import '../base/DailyRoutes.dart';
import '../base/theme/DailyTheme.dart';

class DailyHome extends StatefulWidget {
  const DailyHome({Key? key}) : super(key: key);

  @override
  _DailyHomeState createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  var _weekDay = "", _date = "";
  final _responseDateFormat = DateFormat('yyyy-MM-dd'),
      _cardDateFormat = DateFormat('M月d日');
  final EasyRefreshController _controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  final _logger = Logger(printer: SimplePrinter());
  List<DailyDateStoriesModel> _dailyItems = [];

  _refresh() async {
    try {
      final res = await _fetchItems();
      setState(() {
        _dailyItems = [res];
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "刷新失败 $e");
    }
  }

  _load() async {
    try {
      String date = _dailyItems.last.date ?? "";
      final res = await _fetchItems(date);
      setState(() {
        if ((res.stories ?? []).isEmpty) {
          _controller.finishRefresh();
        } else {
          if (_controller.controlFinishLoad) {
            _controller.resetFooter();
          }
          _dailyItems.add(res);
        }
      });
    } catch (e) {
      _logger.e(e);
      Fluttertoast.showToast(msg: "加载失败 $e");
    }
  }

  Future<DailyDateStoriesModel> _fetchItems([String? date]) async {
    Response response;
    if (date != null) {
      response = await dioBiger
          .get('https://news-at.zhihu.com/api/7/news/before/$date');
    } else {
      response =
          await dioBiger.get('https://news-at.zhihu.com/api/7/stories/latest');
    }
    final res = DailyDateStoriesModel.fromJson(response.data);
    return res;
    // await Future.delayed(const Duration(milliseconds: 500));
    // String text;
    // if (date != null) {
    //   text = await rootBundle.loadString('assets/jsons/$date.json');
    // } else {
    //   text = await rootBundle.loadString('assets/jsons/today.json');
    // }
    // Map<String, dynamic> data = json.decode(text);
    // _logger.v(data);
    // final res = DailyDateStoriesModel.fromJson(data);
    // return res;
  }

  Widget _theme({required Widget child}) {
    // 这里不能用ChangeNotifierProvider，因为DailyThemeProvider是单例不需要自动移除通知
    return ListenableProvider(
      create: (_) => DailyThemeProvider(),
      builder: (context, _) {
        // 不调用Provider.of无法获取通知？
        bool isLight = Provider.of<DailyThemeProvider>(context).brightness == Brightness.light;
        return Theme(
          data: ThemeData(
            scaffoldBackgroundColor: isLight ? Colors.white : Color(0xff1a1a1a),
            appBarTheme: AppBarTheme(
              backgroundColor: isLight ? Colors.white : Color(0xff1a1a1a),
              iconTheme: IconThemeData(
                color: isLight ? Color(0xff191919) : Color(0xff8e8e8e),
              ),
            ),
            dividerColor: isLight ? Color(0xffd3d3d3) : Color(0xff444444),
            textTheme: Theme.of(context).textTheme.copyWith(
                  // 导航栏标题
                  displayLarge: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: isLight ? Color(0xff1a1a1a) : Color(0xff999999),
                  ),
                  // 导航栏星期
                  displayMedium: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: isLight ? Color(0xff444444) : Color(0xff808080),
                  ),
                  // 导航栏日期
                  displaySmall: TextStyle(
                    fontSize: 15,
                    color: isLight ? Color(0xff444444) : Color(0xff808080),
                  ),
                  // Banner标题
                  headlineMedium: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 0.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                  // Banner子标题
                  headlineSmall: const TextStyle(
                    fontSize: 15,
                    color: Color(0xffe7ded7),
                    overflow: TextOverflow.ellipsis,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 0.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                  // 卡片标题
                  titleMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textBaseline: TextBaseline.alphabetic,
                    overflow: TextOverflow.ellipsis,
                    color: isLight ? Color(0xff1a1a1a) : Color(0xff999999),
                  ),
                  // 卡片子标题
                  titleSmall: TextStyle(
                    fontSize: 15,
                    color: isLight ? Color(0xff999999) : Color(0xff646464),
                  ),
                ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    setState(() {
      _weekDay = DateFormat('EEEE', "zh_CN").format(DateTime.now());
      _date = DateFormat('M月d日', "zh_CN").format(DateTime.now());
    });
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return _theme(
      child: LayoutBuilder(
        builder: (context, _) {
          TextStyle? style = Theme.of(context).textTheme.displayLarge;
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekDay,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          _date,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: kToolbarHeight - 20,
                    color: Theme.of(context).dividerColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '知乎日报',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  )
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () => Get.toNamed(DailyRoutes.setting),
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.account_circle,
                      size: 36,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              child: EasyRefresh(
                onRefresh: _refresh,
                onLoad: _load,
                child: CustomScrollView(
                  slivers: () {
                        if (_dailyItems.isNotEmpty) {
                          return <Widget>[
                            SliverToBoxAdapter(
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Container(
                                  height: constraints.maxWidth,
                                  child: DailyHomeBanner(
                                    topStories:
                                        _dailyItems.first.topStories ?? [],
                                    onTap: (story) => Get.toNamed(
                                        DailyRoutes.details,
                                        arguments: {'id': story.id}),
                                  ),
                                );
                              }),
                            )
                          ];
                        }
                        return <Widget>[];
                      }() +
                      _buildDailyList(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildDailyList(context) {
    return () {
      List<Widget> res = [];
      for (int i = 0; i < _dailyItems.length; i++) {
        final daily = _dailyItems[i];
        if (i != 0) {
          var inputDate = daily.date;
          if (inputDate != null && inputDate.length == 8) {
            String newInput =
                '${inputDate.substring(0, 4)}-${inputDate.substring(4, 6)}-${inputDate.substring(6, 8)}';
            DateTime date = _responseDateFormat.parse(newInput);
            String formatDate = _cardDateFormat.format(date);
            res.add(
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text(
                          formatDate,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: .5,
                          color: Theme.of(context).dividerColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
        final stories = daily.stories ?? [];
        res.add(SliverList(
          delegate: SliverChildBuilderDelegate(childCount: stories.length,
              (context, index) {
            final story = stories[index];
            return GestureDetector(
              onTap: () =>
                  Get.toNamed(DailyRoutes.details, arguments: {'id': story.id}),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.title ?? "",
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Container(height: 5),
                            Text(
                              story.hint ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 80, height: 80),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.jpg',
                        imageErrorBuilder: _imageErrorBuilder,
                        fit: BoxFit.cover,
                        image: stories[index].image(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
      }
      return res;
    }();
  }

  Image _imageErrorBuilder(context, error, stackTrace) {
    _logger.e(error);
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }
}
