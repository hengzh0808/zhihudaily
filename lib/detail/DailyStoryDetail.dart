import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zhihudaily/home/DailyHomeModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailyStoryDetail extends StatefulWidget {
  const DailyStoryDetail({Key? key, required this.story}) : super(key: key);
  final Stories story;
  @override
  _DailyStoryDetailState createState() => _DailyStoryDetailState(this.story);
}

class _DailyStoryDetailState extends State<DailyStoryDetail> {
  _DailyStoryDetailState(this.story);
  final Stories story;
  final controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadRequest(
      Uri.parse(story.url ?? ""),
      headers: {'authorization': 'Bearer rQ-s-gjcQdqFf1h8jrkFGQ'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Colors.blue,
        ),
      ),
    );
  }
}
