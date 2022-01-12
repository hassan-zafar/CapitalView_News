import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/CommentListScreen.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';
import 'CommentTextWidget.dart';

class NewsItemWidget extends StatefulWidget {
  static String tag = '/NewsItemWidget';
  final NewsData newsData;
  final Function? onTap;

  NewsItemWidget(this.newsData, {this.onTap});

  @override
  NewsItemWidgetState createState() => NewsItemWidgetState();
}

class NewsItemWidgetState extends State<NewsItemWidget> {
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
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parseHtmlString(widget.newsData.post_title.validate()), maxLines: 2, style: boldTextStyle(size: 14), overflow: TextOverflow.ellipsis),
                  8.height,
                  Text(parseHtmlString(widget.newsData.post_content.validate()), maxLines: 2, style: primaryTextStyle(size: 12), overflow: TextOverflow.ellipsis),
                  8.height,
                  Row(
                    children: [
                      Text(widget.newsData.human_time_diff.validate(), maxLines: 1, style: secondaryTextStyle(size: 12)).expand(),
                      TextIcon(
                        onTap: () async {
                          await CommentListScreen(widget.newsData.iD).launch(context);
                          setDynamicStatusBarColorDetail(milliseconds: 400);
                        },
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesome.commenting_o, size: 14, color: textSecondaryColor),
                            4.width,
                            CommentTextWidget(text: widget.newsData.no_of_comments_text.validate(value: '0').splitBefore(' '),textSize: 12),
                          ],
                        ),
                        text: '',
                      ).visible(widget.newsData.no_of_comments_text.validate(value: '0').splitBefore(' ') != 'No'),
                    ],
                  ),
                ],
              ).expand(),
              8.width,
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  cachedImage(widget.newsData.image.validate(), width: 130, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                  // TextIcon(
                  //   onTap: () async {
                  //     await CommentListScreen(widget.newsData.iD).launch(context);
                  //     setDynamicStatusBarColorDetail(milliseconds: 400);
                  //   },
                  //   prefix: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(FontAwesome.commenting_o, size: 16, color: white),
                  //       4.width,
                  //       CommentTextWidget(
                  //         text: widget.newsData.no_of_comments_text.validate(value: '0'),
                  //         textColor: white,
                  //       ),
                  //     ],
                  //   ),
                  //   text: '',
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).onTap(() {
      widget.onTap?.call();
      // NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
    });
  }
}
