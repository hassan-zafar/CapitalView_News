import 'package:flutter/material.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllHeadingWidget extends StatelessWidget {
  static String tag = '/ViewAllHeadingWidget';
  final String? title;
  final Color? backgroundColor;
  final Color? textColor;
  final Function? onTap;

  ViewAllHeadingWidget({this.title, this.onTap, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          margin: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(color: backgroundColor ?? colorPrimary, borderRadius: radius(defaultRadius)),
          child: Text(title.validate(), style: boldTextStyle(size: 12, color: textColor ?? Colors.white, letterSpacing: 1.5)),
        ),
        Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(),
          child: Text(
            AppLocalizations.of(context)!.translate('view_all'),
            style: boldTextStyle(size: 12),
          ).paddingAll(8).onTap(() => onTap?.call()).visible(onTap != null),
        ),
      ],
    );
  }
}
