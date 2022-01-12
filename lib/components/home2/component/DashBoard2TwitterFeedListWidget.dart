import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/ViewAllHeadingWidget.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/TweetModel.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoard2TwitterFeedListWidget extends StatefulWidget {
  static String tag = '/TwitterFeedListWidget';

  @override
  DashBoard2TwitterFeedListWidgetState createState() => DashBoard2TwitterFeedListWidgetState();
}

class DashBoard2TwitterFeedListWidgetState extends State<DashBoard2TwitterFeedListWidget> with AfterLayoutMixin<DashBoard2TwitterFeedListWidget> {
  final String proxy = kIsWeb ? "http://localhost:8888/" : "";
  final memoizer = AsyncMemoizer<List<TweetModel>>();

  PageController pageController = PageController();

  double currentPage = 0;

  int retryCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DashBoard2TwitterFeedListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (getBoolAsync(DISABLE_TWITTER_WIDGET)) return SizedBox();

    var appLocale = AppLocalizations.of(context);

    return FutureBuilder<List<TweetModel>>(
      future: memoizer.runOnce(() => loadTweets()),
      builder: (_, snap) {
        if (snap.hasError) {
          if (snap.error.toString().isEmpty) {
            return SizedBox();
          } else {
            return Text(snap.error.toString(), style: primaryTextStyle());
          }
        }
        if (snap.hasData) {
          if (snap.data!.isEmpty) {
            return SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              16.height,
              ViewAllHeadingWidget(title: appLocale!.translate('our_twitter_handle'), backgroundColor: white, textColor: scaffoldColorDark),
              8.height,
              Container(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemBuilder: (_, index) {
                        TweetModel data = snap.data![index];

                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          width: context.width() * 0.94,
                          decoration: BoxDecoration(border: Border.all(color: viewLineColor.withOpacity(0.5)), borderRadius: radius(defaultRadius)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cachedImage(data.user!.profile_image_url_https.validate(), height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(30),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextIcon(text: data.user!.name.validate(), suffix: Icon(Octicons.verified, size: 14)),
                                  Text('@${data.user!.screen_name.validate()}', style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  8.height,
                                  Text(data.full_text.validate(), style: primaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis).expand(),
                                  8.height,
                                  Row(
                                    children: [
                                      TextIcon(text: data.retweet_count.validate().toString(), prefix: Icon(EvilIcons.retweet, size: 24)),
                                      8.width,
                                      TextIcon(text: data.favorite_count.validate().toString(), prefix: Icon(Icons.favorite, size: 18, color: Colors.red)),
                                    ],
                                  ),
                                ],
                              ).expand(),
                            ],
                          ),
                        ).onTap(() {
                          launchUrl('https://twitter.com/${data.user!.screen_name}/status/${data.id}');
                        });
                      },
                      itemCount: snap.data!.length,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (v) {
                        setState(() {});
                      },
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: DotIndicator(
                        pageController: pageController,
                        pages: snap.data!,
                        unselectedIndicatorColor: appStore.isDarkMode ? white : black,
                        indicatorColor: appStore.isDarkMode ? gray : getAppPrimaryColor(),
                        onDotTap: (s) {
                          pageController.animateToPage(s, duration: Duration(milliseconds: 5), curve: Curves.bounceIn);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              8.height,
            ],
          );
        } else {
          log(snap.error);
        }
        return snapWidgetHelper(snap);
      },
    );
  }
}
