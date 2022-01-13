import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NewsDetailScreen.dart';

// ignore: must_be_immutable
class QuickReadScreen extends StatefulWidget {
  static String tag = '/QuickReadScreen';
  List<NewsData>? news;

  QuickReadScreen({required this.news});

  @override
  _QuickReadScreenState createState() => _QuickReadScreenState();
}

class _QuickReadScreenState extends State<QuickReadScreen> {
  PageController pageController = PageController();

  int page = 1;
  int numPage = 1;

  bool hasError = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    init();

    loadNews();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
    pageController.addListener(() {
      if ((pageController.page!.toInt() + 1) == widget.news!.length) {
        if (page < numPage) {
          page++;

          appStore.setLoading(true);
          loadNews();
        }
      }
    });
  }

  Future<void> loadNews() async {
    await blogFilterNewsApi({'posts_per_page': postsPerPage}, page).then((value) async {
      appStore.setLoading(false);

      hasError = false;

      numPage = value.num_pages.validate(value: 1);

      if (page == 1) {
        widget.news!.clear();
      }
      widget.news!.addAll(value.posts!);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      hasError = true;
      error = e.toString();
      setState(() {});
    });
  }

  @override
  void dispose() {
    pageController.dispose();

    setDynamicStatusBarColor();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
              ),
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: widget.news.validate().map((e) {
                  return GestureDetector(
                    onHorizontalDragEnd: (v) {
                      if (v.velocity.pixelsPerSecond.dx.isNegative) {
                        NewsDetailScreen(newsData: e).launch(context);
                      }
                    },
                    child: Container(
                      child: Column(
                        children: [
                          cachedImage(e.image, width: context.width(), fit: BoxFit.cover, height: 300),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(parseHtmlString(e.post_title.validate()), style: boldTextStyle(size: 20), maxLines: 4),
                              4.height,
                              Text(e.human_time_diff.validate(), style: secondaryTextStyle()),
                              8.height,
                              Text(parseHtmlString(e.post_content.validate()), style: primaryTextStyle()).expand(),
                              Text('Read more', style: boldTextStyle(color: colorPrimary)).paddingAll(8),
                            ],
                          ).paddingSymmetric(horizontal: 16).expand(),
                        ],
                      ),
                    ).onTap(() {
                      NewsDetailScreen(newsData: e).launch(context);
                    }),
                  );
                }).toList(),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
