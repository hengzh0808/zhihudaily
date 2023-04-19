import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zhihudaily/base/LogUtil.dart';
import 'dart:ui' as ui;

class DailyShareSheet extends StatefulWidget {
  const DailyShareSheet({Key? key}) : super(key: key);

  @override
  _DailyShareSheetState createState() => _DailyShareSheetState();
}

class _DailyShareSheetState extends State<DailyShareSheet>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 250),
    //   vsync: this,
    // );
    // animation = ColorTween(
    //   begin: Colors.black.withOpacity(0),
    //   end: Colors.black.withOpacity(0.4),
    // ).animate(_controller)
    //   ..addListener(
    //     () {
    //       setState(() {});
    //     },
    //   );
    // _controller.forward();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pop(context),
      child: Expanded(
        child: Container(
          // color: animation.value,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromWindow(ui.window).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Text('分享这篇内容'),
          ),
          LayoutBuilder(builder: (context, constraints) {
            final padding = EdgeInsets.only(left: 12, right: 12);
            final itemW =
                (constraints.maxWidth - padding.left - padding.right) / 4;
            final height = itemW * 2;
            return SizedBox(
              height: height,
              child: GridView(
                padding: padding,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1.0),
                children: const <Widget>[
                  Icon(Icons.ac_unit),
                  Icon(Icons.airport_shuttle),
                  Icon(Icons.all_inclusive),
                  Icon(Icons.beach_access),
                  Icon(Icons.cake),
                  Icon(Icons.free_breakfast),
                  Icon(Icons.dangerous),
                  Icon(Icons.face),
                ],
              ),
            );
          }),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () {
              // _controller.reverse();
              Navigator.pop(context);
            },
            child: const Text('取消'),
          )
        ],
      ),
    );
  }
}
