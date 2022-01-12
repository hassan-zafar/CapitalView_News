import 'package:flutter/material.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/QuickReadScreen.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class QuickReadWidget extends StatelessWidget {
  static String tag = '/QuickReadWidget';
  final List<NewsData>? list;

  QuickReadWidget(this.list);

  @override
  Widget build(BuildContext context) {
    if (getBoolAsync(DISABLE_QUICK_READ_WIDGET)) return SizedBox();
    var appLocale = AppLocalizations.of(context)!;

    return Container(
      width: context.width(),
      height: 100,
      margin: EdgeInsets.only(top: 24, left: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: radius(),
        boxShadow: defaultBoxShadow(),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 30,
            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue), padding: EdgeInsets.all(8)),
          ),
          Positioned(
            right: 60,
            top: 40,
            child: Icon(Icons.star, color: Colors.yellow, size: 30),
          ),
          Positioned(
            right: 100,
            top: -23,
            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent), padding: EdgeInsets.all(20)),
          ),
          Positioned(
            right: 150,
            top: 10,
            child: Container(
              height: 60,
              width: 20,
              decoration: BoxDecoration(borderRadius: radius(), border: Border.all(color: Colors.green)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(appLocale.translate('quick_read'), style: boldTextStyle(size: 18)),
              4.height,
              Text(appLocale.translate('quick_read_desc'), style: primaryTextStyle()),
            ],
          ).paddingAll(16),
        ],
      ),
    ).onTap(() {
      QuickReadScreen(news: list).launch(context);
    });
  }
}
