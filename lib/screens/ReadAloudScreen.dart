import 'package:flutter/material.dart';
import 'package:mighty_news/components/ReadAloudDialog.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ReadAloudScreen extends StatefulWidget {
  final String text;

  ReadAloudScreen(this.text);

  @override
  _ReadAloudScreenState createState() => _ReadAloudScreenState();
}

class _ReadAloudScreenState extends State<ReadAloudScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    setDynamicStatusBarColorDetail(milliseconds: 400);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Read Aloud',
        color: getAppBarWidgetBackGroundColor(),
        textColor: getAppBarWidgetTextColor(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            flexibleSpace: ReadAloudDialog(widget.text),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Text(widget.text, style: primaryTextStyle()).paddingOnly(top: 24, right: 16, left: 16, bottom: 16);
            }, childCount: 1),
          ),
        ],
      ),
    );
  }
}
