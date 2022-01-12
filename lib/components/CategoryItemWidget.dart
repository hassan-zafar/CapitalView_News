import 'package:flutter/material.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final CategoryData data;
  final Function? onTap;

  CategoryItemWidget(this.data, {this.onTap});

  @override
  CategoryItemWidgetState createState() => CategoryItemWidgetState();
}

class CategoryItemWidgetState extends State<CategoryItemWidget> {
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
    double h = 100;
    double w = context.width() * 0.3;

    return Container(
      padding: EdgeInsets.all(8),
      width: w,
      height: h,
      decoration: BoxDecoration(borderRadius: radius(defaultRadius)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: cachedImage(widget.data.image, fit: BoxFit.cover, radius: defaultRadius),
          ).cornerRadiusWithClipRRect(defaultRadius),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            color: appStore.myTopics.contains(widget.data.cat_ID) && widget.onTap == null ? colorPrimary.withOpacity(0.5) : Colors.black45,
          ).cornerRadiusWithClipRRect(defaultRadius),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: Colors.white).paddingLeft(2).visible(widget.onTap == null && appStore.myTopics.contains(widget.data.cat_ID)),
              Text(
                widget.data.name.validate(),
                textAlign: TextAlign.center,
                style: boldTextStyle(color: Colors.white, size: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ).paddingOnly(right: 4).expand(),
            ],
          ).center(),
        ],
      ).onTap(() {
        if (widget.onTap != null) {
          widget.onTap!.call();
        } else {
          if (appStore.myTopics.contains(widget.data.cat_ID)) {
            appStore.removeFromMyTopics(widget.data.cat_ID);
          } else {
            appStore.addToMyTopics(widget.data.cat_ID);
          }

          setState(() {});
        }
      }, borderRadius: radius(defaultRadius)),
    );
  }
}
