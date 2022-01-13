import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/WalkThroughScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 2100.milliseconds.delay;
    redirect();
  }

  void redirect() async {
    appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

    updateUserData();

    // if (isMobile) {
    //   remoteConfig = await initializeRemoteConfig().catchError((e) {
    //     log(e.toString());
    //   });
    // }

    int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
    if (themeModeIndex == ThemeModeSystem) {
      appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

    if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
      await 1.seconds.delay;
      WalkThroughScreen().launch(context, isNewTask: true);
    } else if (appStore.isLoggedIn.validate()) {
      await viewProfile().then((data) async {
        await setValue(FIRST_NAME, data.first_name);
        await setValue(LAST_NAME, data.last_name);

        if (data.profile_image != null) {
          if (getStringAsync(LOGIN_TYPE) == LoginTypeApp) {
            await setValue(PROFILE_IMAGE, data.profile_image);
          }
        }

        if (data.my_topics != null) {
          appStore.setMyTopics(data.my_topics!);
          await setValue(MY_TOPICS, jsonEncode(data.my_topics));
        }

        updateUserData();

        if (!getBoolAsync(IS_REMEMBERED, defaultValue: true)) {
          appStore.setLoggedIn(false);
          DashboardScreen().launch(context, isNewTask: true);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
      }).catchError((e) async {
        log(e);
        await logout(context);
      });
    } else {
      await 1.seconds.delay;
      DashboardScreen().launch(context, isNewTask: true);
    }
  }

  void updateUserData() {
    appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
    appStore.setFirstName(getStringAsync(FIRST_NAME));
    appStore.setLastName(getStringAsync(LAST_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));

    String s = getStringAsync(MY_TOPICS);
    appStore.setMyTopics([]);

    if (s.isNotEmpty) {
      List? topics = jsonDecode(s);
      topics.validate().forEach((value) {
        appStore.addToMyTopics(value);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Image.asset(
          'assets/app_logo.png',
          // fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
