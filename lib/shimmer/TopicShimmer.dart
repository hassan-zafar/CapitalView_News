import 'package:flutter/material.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class TopicShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: List.generate(10, (index) {
            double h = 100;
            double w = context.width() * 0.3;

            return Container(
              padding: EdgeInsets.all(8),
              width: w,
              height: h,
              decoration: BoxDecoration(borderRadius: radius(defaultRadius)),
              child: Shimmer.fromColors(
                highlightColor: appStore.isDarkMode ? Colors.black : Colors.white,
                baseColor: appStore.isDarkMode ? Colors.grey.shade50 : Colors.grey[300]!,
                child: Container(width: newsListWidgetSize(context), color: appStore.isDarkMode ? Colors.white10 : Colors.white).cornerRadiusWithClipRRect(16).paddingAll(8),
              ),
            );
          }),
        ).paddingAll(4),
      ),
    );
  }
}
