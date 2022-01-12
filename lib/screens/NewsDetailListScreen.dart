import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/screens/NewsDetailScreen.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class NewsDetailListScreen extends StatefulWidget {
  final List<NewsData>? newsData;
  final int index;
  static String tag = '/NewsDetailListScreen';

  NewsDetailListScreen(this.newsData, {this.index = 0});

  @override
  NewsDetailListScreenState createState() => NewsDetailListScreenState();
}

class NewsDetailListScreenState extends State<NewsDetailListScreen> {
  BannerAd? myBanner;
  InterstitialAd? myInterstitial;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController = PageController(initialPage: widget.index);

    if (isMobile && !getBoolAsync(DISABLE_AD)) {
      myBanner = buildBannerAd()..load();

      if (mAdShowCount < 5) {
        mAdShowCount++;
      } else {
        mAdShowCount = 0;
        loadInterstitialAd();
      }
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          myInterstitial = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          myInterstitial = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (myInterstitial == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
      },
    );
    myInterstitial!.show();
    myInterstitial = null;
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  @override
  void dispose() {
    setDynamicStatusBarColor(milliseconds: 0);

    showInterstitialAd();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          children: widget.newsData!.map((e) => NewsDetailScreen(newsData: e, heroTag: '${e.iD}${currentTimeStamp()}', disableAd: true)).toList(),
        ),
        if (myBanner != null)
          Positioned(
            child: Container(child: AdWidget(ad: myBanner!), color: Colors.white),
            bottom: 0,
            height: AdSize.banner.height.toDouble(),
            width: context.width(),
          ),
      ],
    );
  }
}
