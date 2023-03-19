import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/src/platform_navigation_delegate.dart';

import '../base/dio.dart';
import '../detail/DailyStoryDetailModel.dart';

class DailyStoryDetail extends StatefulWidget {
  const DailyStoryDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _DailyStoryDetailState createState() => _DailyStoryDetailState(this.id);
}

class _DailyStoryDetailState extends State<DailyStoryDetail> {
  _DailyStoryDetailState(this.id);
  final int id;
  DailyStoryDetailModel? _storyDetail;
  late final _controller = WebViewController()
    ..setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) => _onPageFinished(url),
      onWebResourceError: (error) => _onWebResourceError(error),
    ))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  double _webHeight = 0;
  bool _webFinish = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStory();
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
  }

  void _onPageFinished(String url) async {
    // _controller.runJavaScript("document.getElementsByClassName('img-place-holder')[0].style.display = 'none'");
    _controller.runJavaScript(
        "document.getElementsByClassName('ZhihuDailyOIABanner')[0].style.display = 'none'");
    var scrollHeight = await _controller.runJavaScriptReturningResult(
        'document.scrollingElement.scrollHeight') as int;
    setState(() {
      _webHeight = scrollHeight.toDouble();
      _webFinish = true;
    });
  }

  void _onWebResourceError(error) {
    Fluttertoast.showToast(msg: "加载失败 $error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: max(constraints.maxHeight, _webHeight),
                    child: WebViewWidget(controller: _controller),
                  ),
                )
              ],
            ),
            Visibility(
              visible: !_webFinish,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    "加载中",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Color(0xfff6f6f6),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff1a1a1a),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Container(
                  width: 0.5,
                  color: Color(0xffd3d3d3),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xff1a1a1a),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        color: Color(0xff1a1a1a),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline,
                        color: Color(0xff1a1a1a),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.ios_share_outlined,
                        color: Color(0xff1a1a1a),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
