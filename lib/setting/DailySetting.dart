import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../base/DailyThemeProvider.dart';

class DailySetting extends StatefulWidget {
  const DailySetting({Key? key}) : super(key: key);

  @override
  State<DailySetting> createState() => _DailySettingState();
}

class _DailySettingState extends State<DailySetting> {
  Widget _theme(
      {required Widget Function(BuildContext, BoxConstraints, DailyTheme theme)
          childBuilder}) {
    // 这里不能用ChangeNotifierProvider，因为不需要自动移除通知
    return ListenableProvider(
      create: (_) => DailyThemeProvider(),
      builder: (context, _) {
        bool isLight = Provider.of<DailyThemeProvider>(context).brightness ==
            Brightness.light;
        return Theme(
          data: ThemeData(
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
              return childBuilder(context, constraints,
                  Provider.of<DailyThemeProvider>(context).theme);
            },
          ),
        );
      },
    );
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
                    onPressed: () {
                      Fluttertoast.showToast(msg: '待开发');
                    },
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
                          if (theme == DailyTheme.light) {
                            DailyThemeProvider().setTheme(DailyTheme.dark);
                          } else if (theme == DailyTheme.dark) {
                            DailyThemeProvider().setTheme(DailyTheme.system);
                          } else if (theme == DailyTheme.system) {
                            DailyThemeProvider().setTheme(DailyTheme.light);
                          }
                        },
                        iconSize: 48,
                        icon: Center(
                          child: Icon(
                            theme == DailyTheme.system
                                ? Icons.brightness_auto
                                : theme == DailyTheme.dark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          theme == DailyTheme.system
                              ? '跟随系统'
                              : theme == DailyTheme.dark
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
