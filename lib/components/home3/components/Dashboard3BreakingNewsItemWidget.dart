import 'package:flutter/material.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard3BreakingNewsItemWidget extends StatefulWidget {
  static String tag = '/Dashboard3BreakingNewsItemWidget';

  final NewsData newsData;
  final Function? onTap;

  Dashboard3BreakingNewsItemWidget(this.newsData, {this.onTap});

  @override
  Dashboard3BreakingNewsItemWidgetState createState() => Dashboard3BreakingNewsItemWidgetState();
}

class Dashboard3BreakingNewsItemWidgetState extends State<Dashboard3BreakingNewsItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: newsListWidgetSize(context),
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: white.withOpacity(0.1), spreadRadius: 0.5, blurRadius: 1.0)], borderRadius: radius()),
      margin: EdgeInsets.all(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          cachedImage(widget.newsData.image.validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          Container(color: Colors.black38).cornerRadiusWithClipRRect(defaultRadius),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parseHtmlString(widget.newsData.human_time_diff.validate()),
                maxLines: 1,
                style: secondaryTextStyle(size: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parseHtmlString(widget.newsData.post_title.validate()),
                    maxLines: 1,
                    style: boldTextStyle(size: 20, color: white, fontFamily: titleFont()),
                  ),
                  8.height,
                  Text(
                    parseHtmlString(widget.newsData.post_content.validate()),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(color: white, size: 14),
                  ),
                ],
              )
            ],
          ).paddingAll(8),
        ],
      ),
    ).onTap(() {
      widget.onTap?.call();
      //NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
    });
  }
}
