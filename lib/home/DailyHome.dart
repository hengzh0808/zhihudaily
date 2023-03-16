import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:zhihudaily/home/DailyHomeModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DailyHome extends StatefulWidget {
  const DailyHome({Key? key}) : super(key: key);

  @override
  _DailyHomeState createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  var _weekDay = "", _month = "";
  final Dio _dio = Dio();
  //TODO: late关键字
  final EasyRefreshController _controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  final _logger = Logger(printer: SimplePrinter());

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    setState(() {
      _weekDay = DateFormat('EEEE', "zh_CN").format(DateTime.now());
      _month = DateFormat('MMMM', "zh_CN").format(DateTime.now());
    });
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                      Text(_month,
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
          color: Colors.blue,
          child: EasyRefresh(
              onRefresh: _refresh,
              onLoad: _load,
              child: CustomScrollView(
                slivers: <Widget>[_buildBanner()] + _buildStoryCard(),
              )),
        ));
  }

  final _pageViewControler = PageController(initialPage: 0);
  // final _indicatorControler = PageController(initialPage: 1);
  bool _resetingPageIndex = false;
  List<TopStories> _topStories = [];
  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
          height: _topStories.isEmpty ? 0 : 300,
          color: Colors.red,
          child: Stack(
            fit: StackFit.expand,
            children: [
              EasyRefresh(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notifi) {
                    _logger.i(notifi);
                    // if (notifi is ScrollEndNotification &&
                    //     !_resetingPageIndex && _topStories.length >= 4) {
                    //   var currentIndex = _pageViewControler.page?.round();
                    //   _logger.i("PageView stop at $currentIndex");
                    //   if (currentIndex == 0) {
                    //     _logger.i("PageView jumpToPage to 3");
                    //     _resetingPageIndex = true;
                    //     _pageViewControler.jumpToPage(_topStories.length - 2);
                    //   } else if (currentIndex == 4) {
                    //     _resetingPageIndex = true;
                    //     _logger.i("PageView jumpToPage to 1");
                    //     _pageViewControler.jumpToPage(1);
                    //   }
                    //   _resetingPageIndex = false;
                    // }
                    return false;
                  },
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageViewControler,
                    children: _topStories.map((story) {
                      int storyIndex = _topStories.indexOf(story);
                      return FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.jpg',
                        imageErrorBuilder: _imageErrorBuilder,
                        fit: BoxFit.cover,
                        image: story.image ?? "",
                      );
                    }).toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: SmoothPageIndicator(
                    count: _topStories.length,
                    controller: _pageViewControler,
                    effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                        expansionFactor: 2),
                  ),
                ),
              )
            ],
          )),
    );
  }

  List<DailyHomeModel> _dailyItems = [];
  List<SliverList> _buildStoryCard() {
    return _dailyItems.map((daily) {
      final stories = daily.stories ?? [];
      return SliverList(
          delegate: SliverChildBuilderDelegate(childCount: stories.length,
              (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  color: Colors.red,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stories[index].title ?? "",
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                              textBaseline: TextBaseline.alphabetic,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Container(height: 5),
                        Text(stories[index].hint ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black54)),
                      ]),
                ),
              ),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 80, height: 80),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder.jpg',
                    imageErrorBuilder: _imageErrorBuilder,
                    fit: BoxFit.cover,
                    image: stories[index].image()),
              ),
            ],
          ),
        );
      }));
    }).toList();
  }

  Image _imageErrorBuilder(context, error, stackTrace) {
    _logger.e(error);
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }
}

extension _DailyHomeStateViewModel on _DailyHomeState {
  //TODO 验证一下async await的工作机制 为啥这里总异常呢
  _refresh() async {
    try {
      final res = await _fetchItems();
      setState(() {
        _topStories = res.topStories ?? [];
        // if (_topStories.length > 1) {
        //   _topStories = [_topStories.last] + _topStories + [_topStories.first];
        // }
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

  Future<DailyHomeModel> _fetchItems([String? date]) async {
    // Response response;
    // try {
    //   if (date != null) {
    //     response =
    //         await _dio.get('https://news-at.zhihu.com/api/4/news/before/$date');
    //   } else {
    //     response =
    //         await _dio.get('https://news-at.zhihu.com/api/4/news/latest');
    //   }
    //   final res = DailyHomeModel.fromJson(response.data);
    //   setState(() {
    //     if (date == null) {
    //       _dailyItems = [res];
    //     } else {
    //       _dailyItems.add(res);
    //     }
    //   });
    // } on DioError catch (e) {
    //   Fluttertoast.showToast(msg: "请求失败 $e");
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    String text;
    if (date != null) {
      text = await rootBundle.loadString('assets/jsons/$date.json');
    } else {
      text = await rootBundle.loadString('assets/jsons/today.json');
    }
    Map<String, dynamic> data = json.decode(text);
    _logger.v(data);
    final res = DailyHomeModel.fromJson(data);
    return res;
  }
}
