import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zhihudaily/home/DailyHomeModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class DailyHome extends StatefulWidget {
  const DailyHome({Key? key}) : super(key: key);

  @override
  _DailyHomeState createState() => _DailyHomeState();
}

class _DailyHomeState extends State<DailyHome> {
  var _weekDay = "", _month = "";
  final Dio _dio = Dio();
  List<DailyHomeModel> _dailyItems = [];

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
                slivers: _dailyItems.map((daily) {
              final stories = daily.stories ?? [];
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: stories.length, (context, index) {
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
                        constraints: BoxConstraints.tight(const Size(80, 80)),
                        child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.jpg',
                            imageErrorBuilder: _imageErrorBuilder,
                            fit: BoxFit.cover,
                            //TODO 这里有一张图片无法加载
                            image: stories[index].image()),
                      ),
                    ],
                  ),
                );
              }));
            }).toList()),
          )),
    );
  }

  Image _imageErrorBuilder(context, error, stackTrace) {
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }

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
        _dailyItems.add(res);
      });
    } catch (e) {
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
      text = await rootBundle.loadString('assets/json/$date.json');
    } else {
      text = await rootBundle.loadString('assets/json/today.json');
    }
    Map<String, dynamic> data = json.decode(text);
    final res = DailyHomeModel.fromJson(data);
    return res;
  }
}
