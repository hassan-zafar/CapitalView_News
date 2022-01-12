import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/VideoPlayDialog.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class VideoItemWidget extends StatelessWidget {
  static String tag = '/VideoItemWidget';

  final VideoData videoData;
  final Axis axis;

  VideoItemWidget(this.videoData, this.axis);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget() {
      if (videoData.image_url.validate().isNotEmpty) {
        return cachedImage(videoData.image_url.validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius);
      } else if (videoData.video_type.validate() == VideoTypeYouTube) {
        return cachedImage(videoData.video_url.validate().getYouTubeThumbnail(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius);
      }
      return Container(decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: Colors.grey));
    }

    return Container(
      width: newsListWidgetSize(context),
      margin: EdgeInsets.all(8),
      height: getDashBoard2WidgetHeight(),
      decoration: BoxDecoration(
        borderRadius: radius(),
        boxShadow: [BoxShadow(color: gray.withOpacity(0.4), blurRadius: 0.6, spreadRadius: 1.0)],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget(),
          Positioned(
            child: Text(videoData.title.validate(), style: boldTextStyle(color: Colors.white)),
            bottom: 16,
            left: 8,
          ),
          Icon(Icons.play_circle_outline, color: Colors.white,size: 50).center(),
        ],
      ).onTap(() {
        VideoPlayDialog(videoData).launch(context);
      }),
    );
  }
}
