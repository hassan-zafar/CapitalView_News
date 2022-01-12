import 'package:flutter/material.dart';
import 'package:mighty_news/components/home3/components/Dashboard3NewsItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/NewsDetailListScreen.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class Dashboard3NewsListWidget extends StatefulWidget {
  static String tag = '/Dashboard3NewsListWidget';

  List<NewsData>? newsList;
  bool? enableScrolling;
  EdgeInsetsGeometry? padding;

  Dashboard3NewsListWidget(this.newsList, {this.enableScrolling, this.padding});

  @override
  Dashboard3NewsListWidgetState createState() => Dashboard3NewsListWidgetState();
}

class Dashboard3NewsListWidgetState extends State<Dashboard3NewsListWidget> {
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
    return Container(
      child: ListView.builder(
        padding: widget.padding ?? EdgeInsets.all(0),
        physics: widget.enableScrolling.validate() ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => Dashboard3NewsItemWidget(
          widget.newsList![index],
          onTap: () {
            NewsDetailListScreen(widget.newsList, index: index).launch(context);
          },
        ),
        itemCount: widget.newsList!.length,
        shrinkWrap: true,
      ),
    );
  }
}
