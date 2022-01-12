import 'package:flutter/material.dart';
import 'package:mighty_news/components/VideoItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Common.dart';
import 'DashBoard2VideoItemWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class DashBoard2VideoListWidget extends StatefulWidget {
  static String tag = '/VideoListWidget';
  final List<VideoData> videos;
  final Axis axis;

  DashBoard2VideoListWidget(this.videos, {this.axis = Axis.horizontal});

  @override
  _DashBoard2VideoListWidgetState createState() => _DashBoard2VideoListWidgetState();
}

class _DashBoard2VideoListWidgetState extends State<DashBoard2VideoListWidget> with AfterLayoutMixin<DashBoard2VideoListWidget> {
  PageController pageController = PageController();

  double? currentPage = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });
  }



  @override
  void afterFirstLayout(BuildContext context) {
    pages = widget.videos.map((e) => DashBoard2VideoItemWidget(e, widget.axis)).toList();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.axis == Axis.vertical) {
      return GridView.builder(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: widget.axis,
        itemBuilder: (_, index) {
          return VideoItemWidget(widget.videos[index], widget.axis);
        },
        itemCount: widget.videos.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      );
    } else {
      return Container(
        height: getDashBoard2WidgetHeight(),
        child: Stack(
          children: [
            PageView(controller: pageController, children: pages.map((e) => e).toList()),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: pageController,
                pages: pages,
                dotSize: 5,
                unselectedIndicatorColor: white,
                indicatorColor: appStore.isDarkMode ? gray : getAppPrimaryColor(),
                onDotTap: (s) {
                  pageController.animateToPage(s, duration: Duration(milliseconds: 5), curve: Curves.bounceIn);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
