import 'package:flutter/material.dart';
import 'package:mighty_news/components/VideoItemWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Common.dart';

class VideoListWidget extends StatelessWidget {
  static String tag = '/VideoListWidget';
  final List<VideoData> videos;
  final Axis axis;
  final ScrollController? scrollController;

  VideoListWidget(this.videos, {this.axis = Axis.horizontal, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return GridView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: axis,
        itemBuilder: (_, index) {
          return VideoItemWidget(videos[index], axis);
        },
        itemCount: videos.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      );
    } else {
      return Container(
        height: getDashBoard2WidgetHeight(),
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.only(left: 8, right: 8),
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: axis,
          itemBuilder: (_, index) {
            return VideoItemWidget(videos[index], axis);
          },
          itemCount: videos.length,
          shrinkWrap: true,
        ),
      );
    }
  }
}
