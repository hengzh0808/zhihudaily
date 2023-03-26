import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart' hide Response;
import 'package:zhihudaily/home/DailyHomeGetxCtrl.dart';

import '../home/DailyHomeBanner.dart';
import '../base/DailyRoutes.dart';
import '../base/theme/DailyTheme.dart';
import '../base/DailyTextTheme.dart';

class DailyHome extends StatefulWidget {
  const DailyHome({Key? key}) : super(key: key);

  @override
  _DailyHomeState createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  final _responseDateFormat = DateFormat('yyyy-MM-dd'),
      _cardDateFormat = DateFormat('M月d日');

  Widget _theme({required Widget child}) {
    // 这里不能用ChangeNotifierProvider，因为DailyThemeProvider是单例不需要自动移除通知
    return ListenableProvider(
      create: (_) => DailyThemeProvider(),
      builder: (context, _) {
        // 不调用Provider.of无法获取通知？
        bool isLight = Provider.of<DailyThemeProvider>(context).brightness ==
            Brightness.light;
        return Theme(
          data: ThemeData(
            scaffoldBackgroundColor:
                isLight ? Colors.white : const Color(0xff1a1a1a),
            appBarTheme: AppBarTheme(
              backgroundColor: isLight ? Colors.white : const Color(0xff1a1a1a),
              iconTheme: IconThemeData(
                color:
                    isLight ? const Color(0xff191919) : const Color(0xff8e8e8e),
              ),
            ),
            dividerColor:
                isLight ? const Color(0xffd3d3d3) : const Color(0xff444444),
            textTheme: DailyTextTheme(
              // 导航栏标题
              displayLarge: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color:
                    isLight ? const Color(0xff1a1a1a) : const Color(0xff999999),
              ),
              // 导航栏星期
              displayMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color:
                    isLight ? const Color(0xff444444) : const Color(0xff808080),
              ),
              // 导航栏日期
              displaySmall: TextStyle(
                fontSize: 15,
                color:
                    isLight ? const Color(0xff444444) : const Color(0xff808080),
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
                color:
                    isLight ? const Color(0xff1a1a1a) : const Color(0xff999999),
              ),
              // 卡片子标题
              titleSmall: TextStyle(
                fontSize: 15,
                color:
                    isLight ? const Color(0xff999999) : const Color(0xff646464),
              ),
            ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _theme(
      child: LayoutBuilder(
        builder: (context, _) {
          return GetBuilder(
            init: DailyHomeGetxCtrl(),
            builder: (ctrl) {
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
                            Obx(() => Text(
                                  ctrl.weakDay,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                )),
                            Obx(() => Text(
                                  ctrl.date,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ))
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.account_circle,
                          size: 36,
                        ),
                      ),
                    )
                  ],
                ),
                body: EasyRefresh(
                  header: ClassicHeader(
                    textStyle: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color),
                    messageStyle: TextStyle(
                        color:
                            Theme.of(context).textTheme.displayMedium?.color),
                    iconTheme: IconThemeData(
                        color: Theme.of(context).textTheme.displayLarge?.color),
                  ),
                  footer: ClassicFooter(
                    textStyle: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color),
                    messageStyle: TextStyle(
                        color:
                            Theme.of(context).textTheme.displayMedium?.color),
                    iconTheme: IconThemeData(
                        color: Theme.of(context).textTheme.displayLarge?.color),
                  ),
                  controller: ctrl.controller,
                  onRefresh: ctrl.headerRefresh,
                  onLoad: ctrl.footerLoad,
                  child: Obx(
                    () {
                      return CustomScrollView(
                        slivers: () {
                              if (ctrl.dailyItems.isNotEmpty) {
                                return <Widget>[
                                  SliverToBoxAdapter(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SizedBox(
                                          height: constraints.maxWidth,
                                          child: DailyHomeBanner(
                                            topStories: ctrl.topStories,
                                            onTap: (story) => Get.toNamed(
                                                DailyRoutes.details,
                                                arguments: {'id': story.id}),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ];
                              }
                              return <Widget>[];
                            }() +
                            _buildDailyList(context, ctrl),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildDailyList(context, DailyHomeGetxCtrl ctrl) {
    return () {
      List<Widget> res = [];
      for (int i = 0; i < ctrl.dailyItems.length; i++) {
        final daily = ctrl.dailyItems[i];
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
        res.add(
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: stories.length,
              (context, index) {
                final story = stories[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(DailyRoutes.details,
                      arguments: {'id': story.id}),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                          constraints: const BoxConstraints.tightFor(
                              width: 80, height: 80),
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
              },
            ),
          ),
        );
      }
      return res;
    }();
  }

  Image _imageErrorBuilder(context, error, stackTrace) {
    Logger(printer: SimplePrinter()).e(error);
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }
}
