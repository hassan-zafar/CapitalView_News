import 'package:flutter/material.dart';
import 'package:mighty_news/components/home3/components/Dashboard3BreakingNewsItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/NewsDetailListScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/Constants.dart';

class Dashboard3BreakingNewsListWidget extends StatefulWidget {
  static String tag = '/DashboardBreakingNewsListWidget';

  final List<NewsData>? newsList;

  Dashboard3BreakingNewsListWidget(this.newsList);

  @override
  Dashboard3BreakingNewsListWidgetState createState() => Dashboard3BreakingNewsListWidgetState();
}

class Dashboard3BreakingNewsListWidgetState extends State<Dashboard3BreakingNewsListWidget> {
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
      height: dashboard3Item,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8),
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          NewsData newsData = widget.newsList![index];

          return Dashboard3BreakingNewsItemWidget(
            newsData,
            onTap: () {
              NewsDetailListScreen(widget.newsList, index: index).launch(context);
            },
          );
        },
        itemCount: widget.newsList!.length,
        shrinkWrap: true,
      ),
    );
  }
}
