import 'package:flutter/material.dart';
import 'package:mighty_news/components/VideoFileWidget.dart';
import 'package:mighty_news/components/YouTubeEmbedWidget.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class VideoPlayDialog extends StatefulWidget {
  static String tag = '/VideoPlayDialog';
  final VideoData videoData;

  VideoPlayDialog(this.videoData);

  @override
  VideoPlayDialogState createState() => VideoPlayDialogState();
}

class VideoPlayDialogState extends State<VideoPlayDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(milliseconds: 200));

    setStatusBarColor(scaffoldSecondaryDark, statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    super.dispose();
    setOrientationPortrait();

    setDynamicStatusBarColor();
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
            widget.videoData.video_type.validate() == VideoTypeYouTube
                ? YouTubeEmbedWidget(widget.videoData.video_url.validate().convertYouTubeUrlToId()).center()
                : widget.videoData.video_type.validate() == VideoTypeIFrame
                    ? YouTubeEmbedWidget(widget.videoData.video_url.validate(), fullIFrame: true).center()
                    : widget.videoData.video_type.validate() == VideoTypeCustom
                        ? VideoFileWidget(widget.videoData.video_url.validate()).center()
                        : Container(child: Text('Invalid video').center()),
            Positioned(child: BackButton(color: white), top: 20, left: 16),
          ],
        ),
      ),
    );
  }
}
