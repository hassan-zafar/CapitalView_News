import 'package:flutter/material.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:story_view/story_view.dart';

class StoryListScreen extends StatefulWidget {
  final List<NewsData>? list;

  StoryListScreen({this.list});

  @override
  _StoryListScreenState createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  final StoryController controller = StoryController();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor(milliseconds: 400, color: scaffoldColorDark);
  }

  @override
  void dispose() {
    super.dispose();
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
        body: Container(
          child: widget.list.validate().isNotEmpty
              ? GestureDetector(
                  /*onHorizontalDragEnd: (v) {
                    if (v.velocity.pixelsPerSecond.dx.isNegative) {
                      NewsDetailScreen(newsData: widget.list[currentIndex]).launch(context);
                    }
                  },*/
                  onTapDown: (v) {
                    controller.pause();
                  },
                  onTapUp: (v) {
                    controller.play();
                  },
                  child: StoryView(
                    controller: controller,
                    inline: true,
                    repeat: false,
                    onComplete: () {
                      finish(context);
                    },
                    onStoryShow: (v) {
                      log(v);
                    },
                    storyItems: widget.list.validate().map((e) {
                      return StoryItem.inlineImage(
                        url: e.image.validate(),
                        imageFit: BoxFit.fitWidth,
                        controller: controller,
                        duration: Duration(seconds: 5),
                        roundedBottom: false,
                        roundedTop: false,
                        caption: Text(
                          parseHtmlString(e.post_title),
                          style: TextStyle(color: Colors.white, backgroundColor: Colors.black54, fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
