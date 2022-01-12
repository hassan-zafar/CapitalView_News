import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news/models/WalkThroughModel.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashboardScreen.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController();

  List<WalkThroughModel> list = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(Colors.white);
    list.add(
      WalkThroughModel(
        image: 'assets/walk_1.png',
        title: 'Subscribe for updates',
        subTitle: 'Mighty News offers an awesome category filter option which will let you access what you are interested in straight away!',
        color: colorPrimary,
      ),
    );
    list.add(
      WalkThroughModel(
        image: 'assets/walk_3.png',
        title: 'Choose your category',
        subTitle: 'Mighty News is a complete set of incredible, easily importable UI and get regular updates by subscribing to it!',
        color: Color(0xFF6BD19B),
      ),
    );
    list.add(
      WalkThroughModel(
        image: 'assets/walk_2.png',
        title: 'Daily Notifications',
        subTitle: 'Notify your users with the latest news with a daily push notification feature. They are highly interactive and useful.',
        color: Color(0xFFA79BFC),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: list.map((e) {
              return Container(
                height: context.height(),
                width: context.width(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Arc(
                        arcType: ArcType.CONVEY,
                        edge: Edge.TOP,
                        height: 60,
                        child: Container(height: context.height() * 0.5, width: context.width(), color: e.color),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(e.image!, height: context.height() * 0.6, width: newsListWidgetSize(context), fit: BoxFit.fitWidth),
                        16.height,
                        Text(e.title!, style: boldTextStyle(color: Colors.white, size: 24), textAlign: TextAlign.center),
                        16.height,
                        Text(e.subTitle!, style: primaryTextStyle(color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ).paddingOnly(left: 16, right: 16),
                  ],
                ),
              );
            }).toList(),
            onPageChanged: (i) {
              currentPage = i;
              setState(() {});
            },
          ),
          Positioned(
            bottom: 30,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('skip'),
                  decoration: boxDecorationRoundedWithShadow(30),
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                ).onTap(() async {
                  await setValue(IS_FIRST_TIME, false);

                  DashboardScreen().launch(context, isNewTask: true);
                }),
                DotIndicator(
                  pageController: pageController,
                  pages: list,
                ),
                Container(
                  child: Text(currentPage != 2 ? 'next' : 'finish'),
                  decoration: boxDecorationRoundedWithShadow(30),
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                ).onTap(() async {
                  if (currentPage == 2) {
                    await setValue(IS_FIRST_TIME, false);

                    DashboardScreen().launch(context, isNewTask: true);
                  } else {
                    pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                  }
                }),
              ],
            ).paddingOnly(left: 16, right: 16),
          ),
        ],
      ),
    );
  }
}
