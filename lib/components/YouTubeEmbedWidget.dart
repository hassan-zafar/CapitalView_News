import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class YouTubeEmbedWidget extends StatelessWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame});

  @override
  Widget build(BuildContext context) {
    String path = fullIFrame.validate() ? videoId : 'https://www.youtube.com/embed/$videoId';

    return IgnorePointer(
      ignoring: true,
      child: Html(
        data: fullIFrame.validate()
            ? '<html><iframe height="230" style="width:100%" src="$path"></iframe></html>'
            : '<html><iframe height="230" style="width:100%" src="$path" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen"></iframe></html>',
      ),
    ).onTap(() {
      launchUrl(path, forceWebView: true);
    });
  }
}
