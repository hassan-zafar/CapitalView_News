import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/NewsItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'NewsDetailListScreen.dart';

class BookmarkNewsScreen extends StatefulWidget {
  static String tag = '/BookmarkNewsScreen';

  @override
  BookmarkNewsScreenState createState() => BookmarkNewsScreenState();
}

class BookmarkNewsScreenState extends State<BookmarkNewsScreen> {
  ScrollController scrollController = ScrollController();

  bool isLastPage = false;
  int page = 1;
  int numPage = 1;

  List<NewsData> posts = [];

  @override
  void initState() {
    super.initState();
    init();
    setDynamicStatusBarColor();

    loadNews();
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
    LiveStream().on(refreshBookmark, (v) {
      page = 1;
      posts.clear();
      isLastPage = false;

      loadNews();
    });

    await 100.milliseconds.delay;
    appStore.setLoading(true);
  }

  Future<void> loadNews() async {
    await getWishList(page).then((value) async {
      numPage = value.num_pages.validate(value: 1);

      if (page == 1) {
        await setValue(VIEW_ALL_DATA, jsonEncode(value.posts));

        posts.clear();
      }
      if (value.posts != null) {
        posts.addAll(value.posts!);
      }

      appStore.setLoading(false);
    }).catchError((e, id) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(refreshBookmark);
    scrollController.dispose();
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
      child: Scaffold(
        appBar: appBarWidget(appLocalization.translate('Bookmarks'), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Observer(
          builder: (_) => Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              if (posts.isEmpty && !appStore.isLoading) noDataWidget(context),
              ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: posts.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (_, index) {
                  return NewsItemWidget(
                    posts[index],
                    onTap: () {
                      NewsDetailListScreen(posts, index: index).launch(context);
                    },
                  );
                },
              ),
              Positioned(
                bottom: page == 1 ? null : 0,
                child: Loader().center().visible(appStore.isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
