import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

enum TtsState { playing, stopped, paused, continued }

class ReadAloudDialog extends StatefulWidget {
  static String tag = '/ReadAloudDialog';
  final String text;

  ReadAloudDialog(this.text);

  @override
  ReadAloudDialogState createState() => ReadAloudDialogState();
}

class ReadAloudDialogState extends State<ReadAloudDialog> with TickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();

  TtsState ttsState = TtsState.stopped;

  AnimationController? animationController;
  int currentWordPosition = 0;
  int progress = 0;

  bool isLongText = false;
  bool isLongtextComplete = false;
  int temp = 0;
  int count = 0;
  int? charLen;
  List<String> textList = [];

  bool isError = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    init();
  }

  Future<void> init() async {
    isLongText = widget.text.length > 2000;

    if (isLongText) {
      charLen = (widget.text.length ~/ findMiddleFactor(widget.text.length));

      for (int i = 0; i < widget.text.length; i = i + charLen!) {
        textList.insert(temp, widget.text.substring(i, i + charLen!));
        temp = temp + 1;
      }
    }

    bool isLanguageFound = false;

    flutterTts.getLanguages.then((value) {
      Iterable it = value;

      it.forEach((element) {
        if (element.toString().contains(appStore.languageForTTS)) {
          flutterTts.setLanguage(element);
          initTTS();
          isLanguageFound = true;
        }
      });
    });

    if (!isLanguageFound) initTTS();
  }

  void checkText() async {
    if (isLongText) {
      if (!isLongtextComplete && count != textList.length) {
        speak(textList[count]);
      }
    } else {
      speak(widget.text);
    }
  }

  Future<void> initTTS() async {
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      if (isLongText) {
        count = count + 1;
        checkText();
        if (count == textList.length) {
          isLongText = false;
          isLongtextComplete = true;
        }
      } else {
        stop();
      }
    });

    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      currentWordPosition++;

      if (progress < 100) {
        log(progress);

        progress = (currentWordPosition * 110) ~/ text.split(' ').length;
        setState(() {});
      }
    });

    flutterTts.setErrorHandler((msg) async {
      await Future.delayed(Duration(milliseconds: 500));

      if (!isError && mounted) {
        isError = true;
        finish(context);
        toast(errorSomethingWentWrong);
      }
    });

    flutterTts.setCancelHandler(() async {
      /*await Future.delayed(Duration(milliseconds: 200));

      finish(context);
      toast(errorSomethingWentWrong);*/
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    await Future.delayed(Duration(milliseconds: 300));
    checkText();
  }

  Future speak(String text) async {
    currentWordPosition = 0;
    progress = 0;

    animationController!.forward();

    var result = await flutterTts.speak(text);

    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future stop() async {
    currentWordPosition = 0;
    progress = 0;

    animationController!.reverse();

    var result = await flutterTts.stop();

    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6, spreadRadius: 6)]),
      // height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          cachedImage(mTTSImageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                stops: [0.0, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animationController!, color: Colors.black),
                ).onTap(() {
                  ttsState == TtsState.playing ? stop() : checkText();
                }),
                16.width,
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: radius(defaultRadius)),
                      alignment: Alignment.centerLeft,
                      width: 200,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      height: 10,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: radius(defaultRadius)),
                      alignment: Alignment.centerLeft,
                      width: (progress * 2).toDouble(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
