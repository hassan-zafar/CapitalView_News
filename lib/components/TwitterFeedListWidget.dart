import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/models/TweetModel.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/shimmer/HorizontalImageShimmer.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';
import 'ViewAllHeadingWidget.dart';

class TwitterFeedListWidget extends StatefulWidget {
  static String tag = '/TwitterFeedListWidget';

  final Color? backgroundColor;
  final Color? textColor;

  TwitterFeedListWidget({this.backgroundColor, this.textColor});

  @override
  TwitterFeedListWidgetState createState() => TwitterFeedListWidgetState();
}

class TwitterFeedListWidgetState extends State<TwitterFeedListWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TwitterFeedListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //Show Twitter Widget only if you have not disabled in your Word-Press Admin panel
    if (getBoolAsync(DISABLE_TWITTER_WIDGET)) return SizedBox();

    var appLocale = AppLocalizations.of(context);

    return FutureBuilder<List<TweetModel>>(
      future: loadTweets(),
      builder: (_, snap) {
        if (snap.hasError) {
          if (snap.error.toString().isEmpty) {
            return SizedBox();
          } else {
            return Text(errorSomethingWentWrong, style: primaryTextStyle()).center(heightFactor: 10);
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
              ViewAllHeadingWidget(title: appLocale!.translate('our_twitter_handle'), backgroundColor: widget.backgroundColor, textColor: widget.textColor),
              8.height,
              Container(
                height: getDashBoard2WidgetHeight(),
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemBuilder: (_, index) {
                    TweetModel data = snap.data![index];

                    return Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      width: newsListWidgetSize(context),
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
                              Text(data.full_text.validate(), style: primaryTextStyle(), maxLines: getWidgetTwitterLine(), overflow: TextOverflow.ellipsis).expand(),
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
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              8.height,
            ],
          );
        } else {
          log(snap.error);
        }
        //TODO
        return HorizontalImageShimmer();
      },
    );
  }
}
