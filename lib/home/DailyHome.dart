import 'dart:ffi';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base/DioBiger.dart';
import '../detail/DailyStoryDetail.dart';
import '../home/DailyHomeBanner.dart';
import '../Model/DailyDateStoriesModel.dart';

class DailyHome extends StatefulWidget {
  const DailyHome({Key? key}) : super(key: key);

  @override
  _DailyHomeState createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  var _weekDay = "", _date = "";
  // Dart不支持yyyyMMdd如此格式
  final _responseDateFormat = DateFormat('yyyy-MM-dd'),
      _cardDateFormat = DateFormat('M月d日');
  //TODO: late关键字
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
      response = await dioBiger.get(
        'https://news-at.zhihu.com/api/7/news/before/$date',
        options: Options(
          headers: {'authorization': 'Bearer rQ-s-gjcQdqFf1h8jrkFGQ'},
        ),
      );
    } else {
      response = await dioBiger.get(
        'https://news-at.zhihu.com/api/7/stories/latest',
        options: Options(
          headers: {'authorization': 'Bearer rQ-s-gjcQdqFf1h8jrkFGQ'},
        ),
      );
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

  void _onTapStory(int? id) {
    if (id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return DailyStoryDetail(
            id: id,
          );
        }),
      );
    }
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
                    Text(_weekDay,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87)),
                    Text(_date,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            Container(
              width: 1.5,
              height: kToolbarHeight - 20,
              color: Colors.black.withAlpha(25),
            )
          ],
        ),
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
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            height: constraints.maxWidth,
                            child: DailyHomeBanner(
                              topStories: _dailyItems.first.topStories ?? [],
                              onTap: (story) => _onTapStory(story.id),
                            ),
                          );
                        }),
                      )
                    ];
                  }
                  return <Widget>[];
                }() +
                _buildDailyList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDailyList() {
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
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: .5,
                          color: Colors.grey,
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
              onTap: () {
                _onTapStory(story.id);
              },
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black87,
                                textBaseline: TextBaseline.alphabetic,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(height: 5),
                            Text(
                              story.hint ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
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
