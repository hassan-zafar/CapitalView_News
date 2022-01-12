import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mighty_news/components/NewsListWidget.dart';
import 'package:mighty_news/components/home3/components/Dashboard3NewsListWidget.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/shimmer/VerticalTextImageShimmer.dart';
import 'package:mighty_news/shimmer/VerticalTextImageShimmerD2.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';
import 'home2/component/DashBoard2NewsListWidget.dart';

// ignore: must_be_immutable
class PaginatedNewsWidget extends StatefulWidget {
  static String tag = '/PaginatedNewsWidget';
  Map? req;
  int? page;

  double? topPadding;

  final bool? usePreFetch;

  @override
  PaginatedNewsWidgetState createState() => PaginatedNewsWidgetState();

  PaginatedNewsWidget(this.req, {this.page, this.topPadding, this.usePreFetch});
}

class PaginatedNewsWidgetState extends State<PaginatedNewsWidget> {
  ScrollController scrollController = ScrollController();

  List<NewsData> news = [];
  int page = 1;
  int numPage = 1;
  bool isShimmerLoading = true;
  bool isLoading = false;
  bool hasError = false;

  String error = '';

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (page < numPage) {
          page++;
          loadNews();
        }
      }
    });
  }

  Future<void> init() async {
    if (widget.usePreFetch.validate()) {
      String res = getStringAsync(VIEW_ALL_DATA);

      if (res.isNotEmpty) {
        news.clear();
        Iterable it = jsonDecode(res);
        news.addAll(it.map((e) => NewsData.fromJson(e)).toList());

        isLoading = false;
        isShimmerLoading = false;

        setState(() {});
      }
    }

    loadNews();
  }

  Future<void> loadNews() async {
    isLoading = true;
    setState(() {});

    await blogFilterNewsApi(widget.req, page).then((value) async {
      hasError = false;
      isLoading = false;
      isShimmerLoading = false;
      appStore.setLoading(false);

      numPage = value.num_pages.validate(value: 1);

      if (page == 1) {
        await setValue(VIEW_ALL_DATA, jsonEncode(value.posts));

        news.clear();
      }
      news.addAll(value.posts!);

      setState(() {});
    }).catchError((e) {
      isLoading = false;
      isShimmerLoading = false;
      appStore.setLoading(false);

      hasError = true;
      error = e.toString();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant PaginatedNewsWidget oldWidget) {
    log('didUpdateWidget');
    page = 1;
    loadNews();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget viewAllListWidget() {
      if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
        return NewsListWidget(news, padding: EdgeInsets.all(8));
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2) {
        return DashBoard2NewsListWidget(news);
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
        return Dashboard3NewsListWidget(news);
      } else {
        return SizedBox();
      }
    }

    Widget textImageShimmerWidget() {
      if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
        return VerticalTextImageShimmer();
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2) {
        return VerticalTextImageShimmerD2();
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
        return VerticalTextImageShimmerD2();
      } else {
        return SizedBox();
      }
    }

    return Container(
      height: context.height(),
      width: context.width(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 70, top: widget.topPadding ?? 0),
            child: viewAllListWidget().visible(news.isNotEmpty && !hasError),
          ),
          textImageShimmerWidget().paddingAll(8).visible(isShimmerLoading && page == 1),
          Loader().center().visible(isLoading && page != 1),
          noDataWidget(context).visible(!hasError && news.isEmpty && (!isLoading && !isShimmerLoading)),
          Text(error.validate()).center().visible(hasError),
        ],
      ),
    );
  }
}
