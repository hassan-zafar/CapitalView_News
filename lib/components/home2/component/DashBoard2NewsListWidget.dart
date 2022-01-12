import 'package:flutter/material.dart';
import 'package:mighty_news/components/home2/component/DashBoard2NewsItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/NewsDetailListScreen.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class DashBoard2NewsListWidget extends StatefulWidget {
  static String tag = '/NewsListWidget';
  List<NewsData>? newsList;
  bool? enableScrolling;
  EdgeInsetsGeometry? padding;

  DashBoard2NewsListWidget(this.newsList, {this.enableScrolling, this.padding});

  @override
  DashBoard2NewsListWidgetState createState() => DashBoard2NewsListWidgetState();
}

class DashBoard2NewsListWidgetState extends State<DashBoard2NewsListWidget> {
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
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return DashBoard2NewsItemWidget(
          widget.newsList![index],
          onTap: () {
            NewsDetailListScreen(widget.newsList, index: index).launch(context);
          },
        );
      },
      itemCount: widget.newsList!.length,
      shrinkWrap: true,
    );
  }
}
