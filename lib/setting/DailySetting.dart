import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base/DailyThemeProvider.dart';

class DailySetting extends StatefulWidget {
  const DailySetting({Key? key}) : super(key: key);

  @override
  State<DailySetting> createState() => _DailySettingState();
}

class _DailySettingState extends State<DailySetting> {
  Widget _theme(
      {required Widget Function(BuildContext, BoxConstraints, bool isLight)
          childBuilder}) {
    return ChangeNotifierProvider<DailyThemeProvider>(
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
              return childBuilder(context, constraints, isLight);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _theme(childBuilder: (themeContext, constraints, isLight) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Stack(
            children: [
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
                            DailyThemeProvider().setTheme(isLight ? Brightness.dark : Brightness.light);
                          },
                          iconSize: 48,
                          icon: Center(
                            child: Icon(
                              isLight ? Icons.dark_mode : Icons.light_mode,
                            ),
                          ),
                        ),
                        Align(
                          child: Text(
                            isLight ? '夜间模式' : '日间模式',
                            style: TextStyle(color: Theme.of(themeContext).iconTheme.color),
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
                          onPressed: () {},
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
                            style: TextStyle(color: Theme.of(themeContext).iconTheme.color),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
