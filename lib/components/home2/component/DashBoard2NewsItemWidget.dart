import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppWidgets.dart';

class DashBoard2NewsItemWidget extends StatefulWidget {
  static String tag = '/NewsItemWidget';
  final NewsData newsData;
  final Function? onTap;

  DashBoard2NewsItemWidget(this.newsData, {this.onTap});

  @override
  DashBoard2NewsItemWidgetState createState() => DashBoard2NewsItemWidgetState();
}

class DashBoard2NewsItemWidgetState extends State<DashBoard2NewsItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: context.width() * 0.8,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: appStore.isDarkMode ? scaffoldColorDark : white,
          borderRadius: radius(),
          boxShadow: [BoxShadow(color: gray.withOpacity(0.4), blurRadius: 3.0, spreadRadius: 0.0)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: radiusOnly(topLeft: defaultRadius, bottomLeft: defaultRadius),
              child: cachedImage(widget.newsData.image.validate(), width: 130, height: 130, fit: BoxFit.cover),
            ),
            16.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  parseHtmlString(widget.newsData.post_title.validate()),
                  maxLines: 2,
                  style: boldTextStyle(size: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                8.height,
                Text(
                  parseHtmlString(widget.newsData.post_content.validate()),
                  maxLines: 2,
                  style: primaryTextStyle(size: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                8.height,
                Align(
                  child: Text(widget.newsData.human_time_diff.validate(), maxLines: 1, style: secondaryTextStyle(size: 12)),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ).expand(),
          ],
        ),
      ).onTap(() {
        widget.onTap?.call();
        //NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
      }),
    );
  }
}
