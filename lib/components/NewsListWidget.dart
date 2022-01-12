import 'package:flutter/material.dart';
import 'package:mighty_news/components/NewsItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/NewsDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class NewsListWidget extends StatefulWidget {
  static String tag = '/NewsListWidget';
  List<NewsData>? newsList;
  bool? enableScrolling;
  EdgeInsetsGeometry? padding;

  NewsListWidget(this.newsList, {this.enableScrolling, this.padding});

  @override
  NewsListWidgetState createState() => NewsListWidgetState();
}

class NewsListWidgetState extends State<NewsListWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: widget.padding ?? EdgeInsets.all(0),
        physics: widget.enableScrolling.validate() ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return NewsItemWidget(
            widget.newsList![index],
            onTap: () {
              NewsDetailScreen(id: widget.newsList![index].iD.toString(), disableAd: false, newsData: widget.newsList![index]).launch(context);

              // NewsDetailListScreen(widget.newsList, index: index).launch(context);
            },
          );
        },
        itemCount: widget.newsList!.length,
        shrinkWrap: true,
      ),
    );
  }
}
