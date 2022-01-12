import 'package:flutter/material.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalImageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (_, __) => Shimmer.fromColors(
          highlightColor: appStore.isDarkMode ? Colors.black : Colors.white,
          baseColor: appStore.isDarkMode ? Colors.grey.shade50 : Colors.grey[300]!,
          child: Container(width: newsListWidgetSize(context), color: appStore.isDarkMode ? Colors.white10 : Colors.white).cornerRadiusWithClipRRect(16).paddingAll(8),
        ),
      ),
    );
  }
}
