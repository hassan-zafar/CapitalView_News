import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/NewsListWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/shimmer/VerticalTextImageShimmer.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SearchNewsFragment extends StatefulWidget {
  static String tag = '/SearchNewsFragment';

  @override
  SearchNewsFragmentState createState() => SearchNewsFragmentState();
}

class SearchNewsFragmentState extends State<SearchNewsFragment> {
  var searchCont = TextEditingController();
  String searchKey = '';
  ScrollController scrollController = ScrollController();

  List<NewsData> news = [];
  int page = 1;
  int numPage = 1;

  bool isShimmerLoading = true;

  bool hasError = false;

  String error = '';

  int? timer;


  @override
  void initState() {
    super.initState();

    init();

    String s = getStringAsync(SEARCH_DATA);
    if (s.isNotEmpty) {
      Iterable it = jsonDecode(s);

      news.addAll(it.map((e) => NewsData.fromJson(e)).toList());
      isShimmerLoading = false;
      hasError = false;
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (page < numPage) {
          page++;

          appStore.isLoading = true;
          setState(() {});

          init();
        }
      }
    });
  }

  init() async {
    Map req = {
      'text': searchKey,
      'posts_per_page': postsPerPage,
    };
    await blogFilterNewsApi(req, page).then((value) async {
      hasError = false;

      appStore.setLoading(false);
      isShimmerLoading = false;

      numPage = value.num_pages.validate(value: 1);
      if (page == 1) {
        news.clear();

        await setValue(SEARCH_DATA, jsonEncode(value.posts));
      }
      news.addAll(value.posts!);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      isShimmerLoading = false;

      hasError = getStringAsync(SEARCH_DATA).isEmpty;
      error = e.toString();
      setState(() {});
    });
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
    var appLocalization = AppLocalizations.of(context)!;

    return Container(
      height: context.height(),
      width: context.width(),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
            child: AppTextField(
              controller: searchCont,
              textFieldType: TextFieldType.OTHER,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: radius(30)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: viewLineColor), borderRadius: radius(30)),
                hintText: appLocalization.translate('search_hintText'),
                hintStyle: primaryTextStyle(),
                contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                prefixIcon: Icon(Icons.search_rounded, color: context.theme.iconTheme.color),
              ),
              onChanged: (s) async {
                appStore.setLoading(false);
                searchKey = s.trim();
                setState(() { });
                page = 1;
                  if(timer == null){
                    timer=1500;
                    await timer.milliseconds.delay;
                    appStore.setLoading(true);
                    init();
                    timer=null;
                  }
              },
            ),
          ),
          Positioned(
            top: news.isEmpty ? 0 : 90,
            child: Container(
              height: context.height(),
              width: context.width(),
              child: news.isNotEmpty
                  ? SingleChildScrollView(
                      padding: EdgeInsets.only(top: 8, right: 0, left: 0, bottom: 200),
                      controller: scrollController,
                      child: NewsListWidget(news, padding: EdgeInsets.all(8)),
                    )
                  : noDataWidget(context).visible(!hasError && !appStore.isLoading && !isShimmerLoading),
            ),
          ),
          VerticalTextImageShimmer().paddingOnly(top: news.isNotEmpty ? 0 : 90, bottom: 16, left: 8, right: 8).center().visible(isShimmerLoading),
         Loader().paddingOnly(top: news.isNotEmpty ? 0 : 90, bottom: 16, left: 8, right: 8).center().visible(appStore.isLoading),
          Text(error.validate(), style: primaryTextStyle()).center().visible(hasError),
        ],
      ),
    );
  }
}
