import 'dart:math';

import 'package:flutter/material.dart';
import '../Model/DailyDateStoriesModel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:logger/logger.dart';

final _logger = Logger(printer: SimplePrinter());

class DailyHomeBanner extends StatefulWidget {
  const DailyHomeBanner({Key? key, required this.topStories, this.onTap})
      : super(key: key);
  final List<TopStories> topStories;
  final void Function(TopStories)? onTap;

  @override
  State<DailyHomeBanner> createState() =>
      _DailyHomeBannerState(topStories, onTap);
}

class _PageController1 extends PageController {
  final initialPage;
  _PageController1(this.initialPage) : super(initialPage: initialPage);

  @override
  void attach(ScrollPosition position) {
    // TODO: implement attach
    super.attach(position);
  }
}

class _DailyHomeBannerState extends State<DailyHomeBanner> {
  _DailyHomeBannerState(this.topStories, this.onTap);
  final List<TopStories> topStories;
  final void Function(TopStories)? onTap;
  final _pageViewControler = _PageController1(0);
  final _pageViewControler1 = _PageController1(0);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(fit: StackFit.expand, children: [
      NotificationListener<Notification>(
        onNotification: _scrollNotification,
        child: PageView(
          physics: const ClampingScrollPhysics(),
          controller: _pageViewControler,
          children: () {
            var subWidgets = topStories.map((story) {
              int storyIndex = topStories.indexOf(story);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onTap?.call(story);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.jpg',
                      imageErrorBuilder: _imageErrorBuilder,
                      fit: BoxFit.cover,
                      image: story.image ?? "",
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "$storyIndex",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title ?? "",
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            story.hint ?? "",
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
            if (subWidgets.length > 1) {
              subWidgets.insert(0, subWidgets.last);
              subWidgets.add(subWidgets[1]);
            }
            return subWidgets;
          }(),
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: _BannerIndicator(
            count: topStories.length,
            controller: _pageViewControler,
            effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 4,
                expansionFactor: 2,
                dotColor: Colors.grey,
                activeDotColor: Colors.white),
          ),
        ),
      )
    ]));
  }

  bool _resetingPageIndex = false;
  bool _scrollNotification(notifi) {
    if (notifi is ScrollEndNotification &&
        !_resetingPageIndex &&
        topStories.length > 1) {
      var currentIndex = _pageViewControler.page?.round();
      _logger.i("PageView stop at $currentIndex");
      if (currentIndex == 0) {
        _logger.i("PageView jumpToPage to 3");
        _resetingPageIndex = true;
        _pageViewControler.jumpToPage(topStories.length);
      } else if (currentIndex == topStories.length + 1) {
        _resetingPageIndex = true;
        _logger.i("PageView jumpToPage to 1");
        _pageViewControler.jumpToPage(1);
      }
      _resetingPageIndex = false;
    }
    return false;
  }

  Image _imageErrorBuilder(context, error, stackTrace) {
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }
}

class _BannerIndicator extends AnimatedWidget {
  // Page view controller
  final PageController controller;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  ///
  /// This will only rotate the canvas in which the dots
  /// are drawn,
  /// It will not affect [effect.dotWidth] and [effect.dotHeight]
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// on dot clicked callback
  final OnDotClicked? onDotClicked;

  const _BannerIndicator({
    Key? key,
    required this.controller,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    // 这里listenable是指示器跟着滚动的精髓（每帧都rebuild）
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return SmoothIndicator(
      offset: _offset,
      count: count,
      effect: effect,
      textDirection: textDirection,
      axisDirection: axisDirection,
      onDotClicked: onDotClicked,
    );
  }

  double get _offset {
    try {
      var page = controller.page ?? controller.initialPage.toDouble();
      var offset = min(count - 1, max(0, page - 1)).toDouble();
      _logger.d(offset);
      return offset;
    } catch (_) {
      return controller.initialPage.toDouble();
    }
  }
}
