import 'package:flutter/material.dart';
import 'package:mighty_news/components/BreakingNewsMarqueeWidget.dart';

import 'package:mighty_news/components/VideoListWidget.dart';
import 'package:mighty_news/components/ViewAllHeadingWidget.dart';
import 'package:mighty_news/components/home3/components/Dashboard3BreakingNewsListWidget.dart';
import 'package:mighty_news/components/home3/components/Dashboard3NewsListWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/ViewAllNewsScreen.dart';
import 'package:mighty_news/screens/ViewAllVideoScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../QuickReadWidget.dart';
import '../StoryListWidget.dart';
import '../TwitterFeedListWidget.dart';
import '../ViewAllHeadingWidget.dart';

class Dashboard3Widget extends StatefulWidget {
  final AsyncSnapshot<DashboardResponse> snap;

  Dashboard3Widget(this.snap);

  @override
  Dashboard3WidgetState createState() => Dashboard3WidgetState();
}

class Dashboard3WidgetState extends State<Dashboard3Widget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos ? true : false,
      child: Container(
        height: context.height(),
        width: context.width(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BreakingNewsMarqueeWidget(data: widget.snap.data!.breaking_post),

              StoryListWidget(
                list: widget.snap.data!.story_post,
                backgroundColor: white,
                textColor: scaffoldColorDark,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  20.height,
                  ViewAllHeadingWidget(
                    title: appLocalization.translate('breaking_News').toUpperCase(),
                    backgroundColor: white,
                    textColor: scaffoldColorDark,
                    onTap: () {
                      ViewAllNewsScreen(title: 'breaking_News', req: {'posts_per_page': postsPerPage, FILTER: FILTER_FEATURE}).launch(context);
                    },
                  ),
                  8.height,
                  Dashboard3BreakingNewsListWidget(widget.snap.data!.breaking_post),
                ],
              ).visible(widget.snap.data!.breaking_post.validate().isNotEmpty),

              // Quick Read
              QuickReadWidget(widget.snap.data!.recent_post),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.height,
                  ViewAllHeadingWidget(
                    title: appLocalization.translate('recent_News').toUpperCase(),
                    textColor: scaffoldColorDark,
                    backgroundColor: white,
                    onTap: () {
                      ViewAllNewsScreen(title: 'recent_News', req: {'posts_per_page': postsPerPage}).launch(context);
                    },
                  ),
                  8.height,
                  Dashboard3NewsListWidget(widget.snap.data!.recent_post, padding: EdgeInsets.symmetric(horizontal: 8)),
                ],
              ).visible(widget.snap.data!.recent_post.validate().isNotEmpty),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.height,
                  ViewAllHeadingWidget(
                    title: appLocalization.translate('videos').toUpperCase(),
                    backgroundColor: white,
                    textColor: scaffoldColorDark,
                    onTap: () {
                      ViewAllVideoScreen().launch(context);
                    },
                  ),
                  8.height,
                  VideoListWidget(widget.snap.data!.videos.validate(), axis: Axis.horizontal),
                ],
              ).visible(widget.snap.data!.videos.validate().isNotEmpty),

              16.height,

              //Show Twitter Widget only if you have not disabled in your Word-Press Admin panel
              TwitterFeedListWidget(
                backgroundColor: white,
                textColor: scaffoldColorDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
