import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zhihudaily/home/DailyHome.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zhihudaily',
      home: const DailyHome(),
      // home: HomeContent(),
    );
  }
}


// 主体组件
class HomeContent extends StatelessWidget{
    @override
    Widget build(BuildContext context) {
        return Center(
            // Container组件
            child: Container(
                // Text组件
                child:Text(
                    '科技创新的星辰大海更让人心潮澎湃，这才是互联网科技巨头们应该有的担当',
                    textAlign: TextAlign.left,
                    overflow:TextOverflow.ellipsis,
                    maxLines:2,
                    textScaleFactor:1.5,
                    style:TextStyle(
                        fontSize: 20.0,
                        color:Colors.red,
                        fontWeight:FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.green,
                        decorationStyle: TextDecorationStyle.dashed,
                        letterSpacing: 8.0
                    ),
                ),
                height:300.0,
                width:300.0,
                decoration: BoxDecoration(
                    color:Colors.yellow,
                    border: Border.all(
                        color:Colors.blue,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(9),
                    ),
                ),
                // padding: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                margin:EdgeInsets.fromLTRB(20, 20, 20, 20),
                // transform: Matrix4.translationValues(-50, -10, 0),
                // transform:Matrix4.rotationZ(0.2),
                transform: Matrix4.diagonal3Values(0.8, 1, 1),
                alignment: Alignment.bottomCenter,

            )
        );
    }
}