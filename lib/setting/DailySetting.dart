import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../base/theme/DailyThemeGetxCtrl.dart';
import '../base/theme/DailyTheme.dart';

class DailySetting extends StatelessWidget {
  DailySetting({Key? key}) : super(key: key);

  Widget _theme(
      {required Widget Function(
              BuildContext, BoxConstraints, DailyThemeMode theme)
          childBuilder}) {
    return GetBuilder<DailyThemeGetxCtrl>(
        init: DailyThemeGetxCtrl(),
        builder: (controller) {
          bool isLight = controller.brightness == Brightness.light;
          return Theme(
            data: ThemeData(
              scaffoldBackgroundColor:
                  isLight ? Colors.white : Color(0xff1a1a1a),
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
                return childBuilder(context, constraints, controller.theme);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _theme(childBuilder: (themeContext, constraints, theme) {
      return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Text(
                    '欢迎来到知乎日报',
                    style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(themeContext).iconTheme.color,
                    ),
                  ),
                  Container(
                    height: 12,
                  ),
                  CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      '去登陆',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    onPressed: () => Get.toNamed('/login'),
                  )
                ],
              ),
            ),
            Positioned(
              left: 12,
              bottom: 50 + MediaQuery.of(context).padding.bottom,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (theme == DailyThemeMode.light) {
                            DailyTheme().setTheme(DailyThemeMode.dark);
                          } else if (theme == DailyThemeMode.dark) {
                            DailyTheme().setTheme(DailyThemeMode.system);
                          } else if (theme == DailyThemeMode.system) {
                            DailyTheme().setTheme(DailyThemeMode.light);
                          }
                        },
                        iconSize: 48,
                        icon: Center(
                          child: Icon(
                            theme == DailyThemeMode.system
                                ? Icons.brightness_auto
                                : theme == DailyThemeMode.dark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          theme == DailyThemeMode.system
                              ? '跟随系统'
                              : theme == DailyThemeMode.dark
                                  ? '夜间模式'
                                  : '日间模式',
                          style: TextStyle(
                              color: Theme.of(themeContext).iconTheme.color),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Fluttertoast.showToast(msg: '待开发');
                        },
                        iconSize: 48,
                        icon: const Center(
                          child: Icon(
                            Icons.settings,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          '设置',
                          style: TextStyle(
                              color: Theme.of(themeContext).iconTheme.color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
