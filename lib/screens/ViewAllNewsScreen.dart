import 'package:flutter/material.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/PaginatedNewsWidget.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllNewsScreen extends StatefulWidget {
  final String? title;
  final Map? req;
  static String tag = '/ViewAllNewsScreen';

  ViewAllNewsScreen({this.title, this.req});

  @override
  ViewAllNewsScreenState createState() => ViewAllNewsScreenState();
}

class ViewAllNewsScreenState extends State<ViewAllNewsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setDynamicStatusBarColor(milliseconds: 400);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setDynamicStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos ? true : false,
      child: Scaffold(
        appBar: appBarWidget(appLocalization.translate(widget.title), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: PaginatedNewsWidget(widget.req),
      ),
    );
  }
}
