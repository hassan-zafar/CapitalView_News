import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:mighty_news/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Colors.dart';
import 'Constants.dart';

Color getAppPrimaryColor() => appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary;

String? titleFont() {
  return GoogleFonts.cormorantGaramond().fontFamily;
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launch(url, forceWebView: forceWebView, enableJavaScript: true).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

InputDecoration inputDecoration(BuildContext context, {String? hint, Widget? prefixIcon}) {
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: viewLineColor)),
    labelText: hint,
    labelStyle: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
    contentPadding: EdgeInsets.only(top: 8, bottom: 8),
    prefixIcon: prefixIcon,
  );
}

String? removeLastCharacter(String? str, {int length = 1}) {
  String? result;
  if ((str != null) && (str.length >= length)) {
    result = str.substring(0, str.length - length);
  }

  return result;
}

Widget titleWidget(String title) {
  return Row(
    children: [
      VerticalDivider(color: colorPrimary, thickness: 4).withHeight(10),
      8.width,
      Text(title, style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
    ],
  ).paddingLeft(16);
}

String durationFormatter(int milliSeconds) {
  int seconds = milliSeconds ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime = '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';
  return formattedTime;
}

bool isLoggedInWithGoogleOrApple() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeGoogle || getStringAsync(LOGIN_TYPE) == LoginTypeApple;
}

double getDashBoard2WidgetHeight() {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
    return dashboard1ComponentHeight;
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2) {
    return dashboard2ComponentHeight;
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
    return dashboard3ComponentHeight;
  } else {
    return 180.0;
  }
}

Color getAppBarWidgetBackGroundColor() {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
    return appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary;
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2 || getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
    return appStore.isDarkMode ? scaffoldSecondaryDark : white;
  } else {
    return appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary;
  }
}

Color getAppBarWidgetTextColor() {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
    return appStore.isDarkMode ? white : white;
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2 || getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
    return appStore.isDarkMode ? white : black;
  } else {
    return appStore.isDarkMode ? white : black;
  }
}

int getWidgetTwitterLine() {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
    return dashboard3ItemTwitterLine;
  } else {
    return 3;
  }
}

Future<void> setDynamicStatusBarColor({Color? color, int milliseconds = 100}) async {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
    setStatusBarColor(color ?? getAppPrimaryColor() /*, statusBarIconBrightness: Brightness.light*/, delayInMilliSeconds: milliseconds);
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2 || getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
    setStatusBarColor(color ?? (appStore.isDarkMode ? scaffoldSecondaryDark : white) /*, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark*/, delayInMilliSeconds: milliseconds);
  }
}

Future<void> setDynamicStatusBarColorDetail({int milliseconds = 100}) async {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) != 1 && getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
    setStatusBarColor(appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white /*, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark*/, delayInMilliSeconds: milliseconds);
  } else {
    if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2 || getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 3) {
      setStatusBarColor(Colors.transparent /*, statusBarIconBrightness: Brightness.light*/, delayInMilliSeconds: milliseconds);
    } else {
      setStatusBarColor(getAppPrimaryColor() /*, statusBarIconBrightness: Brightness.light*/, delayInMilliSeconds: milliseconds);
    }
  }
}

Brightness getSystemIconBrightness() {
  int dashVariant = getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage);
  int detailVariant = getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1);

  if (dashVariant != 1 && detailVariant == 1) {
    return appStore.isDarkMode ? Brightness.light : Brightness.dark;
  } else {
    if (detailVariant == 2 || detailVariant == 3) {
      return Brightness.light;
    } else {
      return appStore.isDarkMode ? Brightness.dark : Brightness.light;
    }
  }
}

Brightness getSystemBrightness() {
  int dashVariant = getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage);
  int detailVariant = getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1);

  if (dashVariant != 1 && detailVariant == 1) {
    return appStore.isDarkMode ? Brightness.dark : Brightness.light;
  } else {
    if (detailVariant == 2 || detailVariant == 3) {
      return Brightness.dark;
    } else {
      return appStore.isDarkMode ? Brightness.light : Brightness.dark;
    }
  }
}

Future<RemoteConfig> initializeRemoteConfig() async {
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  final defaults = <String, dynamic>{};
  await remoteConfig.setDefaults(defaults);

  remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchInterval: Duration.zero, fetchTimeout: Duration.zero));
  await remoteConfig.fetch().catchError(log);

  await remoteConfig.fetchAndActivate().then((value) {
    log('RemoteConfig initialized');
  });

  await setValue(LAST_UPDATE_DATE, remoteConfig.getString(LAST_UPDATE_DATE));
  await setValue(FORCE_UPDATE_VERSION_CODE, remoteConfig.getInt(FORCE_UPDATE_VERSION_CODE));

  return remoteConfig;
}

void checkForceUpdateForAndroid({required int currentVersion, required int forceUpdateVersion, required String packageName}) {
  if (isAndroid) {
    if (currentVersion < forceUpdateVersion) {
      launchUrl('$playStoreBaseURL$packageName');
      exit(0);
    }
  }
}

///  HttpOverrides.global = HttpOverridesSkipCertificate();
class HttpOverridesSkipCertificate extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

double newsListWidgetSize(BuildContext context) => isWeb ? 300 : context.width() * 0.6;

String storeBaseURL() {
  return isAndroid ? playStoreBaseURL : appStoreBaseUrl;
}

String getArticleReadTime(BuildContext context, String content) {
  int length = parseHtmlString(content).split(' ').length;

  double time = length / 200;

  int minutes = time.ceilToDouble().toInt();

  if (minutes > 1) {
    return '$minutes mins read'.toUpperCase();
  } else {
    return '$minutes min read'.toUpperCase();
  }
}

/// find middle factor from list
int findMiddleFactor(int n) {
  List<int?> num = [];
  for (int i = 1; i <= n; i++) {
    if (n % i == 0 && i > 1 && i < 20) {
      num.add(i);
    }
  }
  return num[num.length ~/ 2]!;
}
