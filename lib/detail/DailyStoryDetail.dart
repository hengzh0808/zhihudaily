import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zhihudaily/base/LogUtil.dart';
import 'package:zhihudaily/share/DailyShareSheet.dart';

import '../base/theme/DailyTheme.dart';
import '../base/DioBiger.dart';
import '../Model/DailyStoryDetailModel.dart';
import '../Model/DailyStoryExtraInfo.dart';

class DailyStoryDetail extends StatefulWidget {
  const DailyStoryDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _DailyStoryDetailState createState() => _DailyStoryDetailState(this.id);
}

class _DailyStoryDetailState extends State<DailyStoryDetail>
    with SingleTickerProviderStateMixin {
  _DailyStoryDetailState(this.id);
  final int id;
  DailyStoryDetailModel? _storyDetail;
  DailyStoryExtraInfo? _storyExtraInfo;
  late final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setUserAgent('ZhihuHybrid');
  bool _webFinish = false;
  double _webProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStory();
    _setWebDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return _theme(
      childBuilder: (themeContext, constraints, theme) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  child: _buildWebView(context),
                ),
              ),
              _buildBottomBar(themeContext),
            ],
          ),
        );
      },
    );
  }

  Widget _theme(
      {required Widget Function(
              BuildContext, BoxConstraints, DailyThemeMode theme)
          childBuilder}) {
    // 这里不能用ChangeNotifierProvider，因为不需要自动移除通知
    return ListenableProvider(
      create: (_) => DailyThemeProvider(),
      builder: (context, _) {
        bool isLight = DailyTheme().brightness == Brightness.light;
        return Theme(
          data: ThemeData(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: isLight ? Color(0xff191919) : Color(0xff8e8e8e),
            ),
            scaffoldBackgroundColor: isLight ? Colors.white : Color(0xff1a1a1a),
            appBarTheme: AppBarTheme(
              backgroundColor: isLight ? Colors.white : Color(0xff1a1a1a),
              elevation: 0,
              iconTheme: IconThemeData(
                color: isLight ? Color(0xff191919) : Color(0xff8e8e8e),
              ),
            ),
            iconTheme: IconThemeData(
              color: isLight ? Color(0xff191919) : Color(0xff8e8e8e),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return childBuilder(context, constraints, DailyTheme().theme);
            },
          ),
        );
      },
    );
  }

  Widget _buildWebView(BuildContext themeContext) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          WebViewWidget(controller: _controller),
          Visibility(
            visible: !_webFinish,
            child: Center(
              child: CircularProgressIndicator(
                value: _webProgress,
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _buildBottomBar(BuildContext themeContext) {
    return Builder(builder: (context) {
      return SafeArea(
        top: false,
        left: false,
        right: false,
        child: Container(
          height: 50,
          color: Colors.green,
          child: Row(
            children: [
              IconButton(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(themeContext).appBarTheme.iconTheme?.color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Container(
                  width: 0.5,
                  color: Theme.of(themeContext).dividerColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // GestureDetector(
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Theme.of(themeContext)
                                  .appBarTheme
                                  .iconTheme
                                  ?.color,
                            ),
                            SizedOverflowBox(
                              alignment: Alignment.topLeft,
                              size: const Size(0, 10),
                              child: () {
                                int? count = _storyExtraInfo?.count?.comments;
                                if (count != null && count > 0) {
                                  return Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(themeContext)
                                          .appBarTheme
                                          .iconTheme
                                          ?.color,
                                    ),
                                  );
                                }
                              }(),
                            )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Icon(
                              Icons.thumb_up_outlined,
                              color: Theme.of(themeContext)
                                  .appBarTheme
                                  .iconTheme
                                  ?.color,
                            ),
                            SizedOverflowBox(
                              alignment: Alignment.topLeft,
                              size: const Size(0, 10),
                              child: () {
                                int? count = _storyExtraInfo?.count?.likes;
                                if (count != null && count > 0) {
                                  return Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(themeContext)
                                          .appBarTheme
                                          .iconTheme
                                          ?.color,
                                    ),
                                  );
                                }
                              }(),
                            )
                          ],
                        ),
                        Icon(
                          Icons.favorite_outline,
                          color: Theme.of(themeContext)
                              .appBarTheme
                              .iconTheme
                              ?.color,
                        ),
                        IconButton(
                          onPressed: () {
                            showBottomSheet(
                              enableDrag: false,
                              backgroundColor: Colors.red,
                              transitionAnimationController:
                                  AnimationController(
                                duration: Duration(microseconds: 0),
                                reverseDuration: Duration(microseconds: 0),
                                debugLabel: 'BottomSheet',
                                vsync: this,
                              ),
                              context: context,
                              builder: (context) {
                                return DailyShareSheet();
                              },
                            );
                          },
                          icon: Icon(
                            Icons.ios_share_outlined,
                            color: Theme.of(themeContext)
                                .appBarTheme
                                .iconTheme
                                ?.color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _loadStory() async {
    try {
      Response response =
          await dioBiger.get('https://news-at.zhihu.com/api/7/story/$id');
      final storyDetail = DailyStoryDetailModel.fromJson(response.data);
      setState(() {
        _storyDetail = storyDetail;
        _controller.loadRequest(Uri.parse(storyDetail.url ?? ""));

        //TOOD: 加载本地或者字符串css不生效
        // String body = storyDetail.body ?? "";
        // String html =
        //     "<html><head><meta name='viewport' content='initial-scale=1.0,user-scalable=no'><link type='text/css' rel='stylesheet' href='http://news-at.zhihu.com/css/news_qa.auto.css?v=4b3e3'></link></head>$body</html>";
        // _controller.loadHtmlString(html);
        // _controller.loadFlutterAsset('assets/html/story.html');
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "加载失败 $e");
    }

    try {
      Response response =
          await dioBiger.get('https://news-at.zhihu.com/api/7/story-extra/$id');
      final storyExtraInfo = DailyStoryExtraInfo.fromJson(response.data);
      setState(() {
        _storyExtraInfo = storyExtraInfo;
      });
    } catch (e) {}
  }

  void _setWebDelegate() {
    _controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) {
        // _controller.runJavaScript("document.getElementsByClassName('img-place-holder')[0].style.display = 'none'");
        // var scrollHeight = await _controller.runJavaScriptReturningResult('document.scrollingElement.scrollHeight') as int;
        setState(() {
          _webFinish = true;
        });
      },
      onWebResourceError: (error) {
        Fluttertoast.showToast(msg: "加载失败 $error");
      },
      onProgress: (progress) {
        if (mounted) {
          setState(() {
            _webProgress = progress / 100.0;
          });
        }
      },
    ));
  }
}
