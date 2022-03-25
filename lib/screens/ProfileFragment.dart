import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/LanguageSelectionWidget.dart';
import 'package:mighty_news/components/SocialLoginWidget.dart';
import 'package:mighty_news/components/ThemeSelectionDialog.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/FontSizeModel.dart';
import 'package:mighty_news/models/LanguageModel.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/AboutAppScreen.dart';
import 'package:mighty_news/screens/ChangePasswordScreen.dart';
import 'package:mighty_news/screens/ChooseTopicScreen.dart';
import 'package:mighty_news/screens/EditProfileScreen.dart';
import 'package:mighty_news/screens/LoginScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import 'BookmarkNewsScreen.dart';
import 'ChooseDashboardPageVariant.dart';
import 'ChooseDetailPageVariantScreen.dart';
import 'DashboardScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Observer(
      builder: (_) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: context.statusBarHeight),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: appStore.isDarkMode
                          ? scaffoldSecondaryDark
                          : Colors.white,
                      child: appStore.isLoggedIn
                          ? Row(
                              children: [
                                appStore.userProfileImage.validate().isEmpty
                                    ? Icon(Icons.person_outline, size: 40)
                                    : cachedImage(
                                            appStore.userProfileImage
                                                .validate(),
                                            usePlaceholderIfUrlEmpty: true,
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(60),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${appStore.userFirstName.validate()} ${appStore.userLastName.validate()}',
                                        style: boldTextStyle()),
                                    Text(appStore.userEmail.validate(),
                                            style: primaryTextStyle())
                                        .fit(),
                                  ],
                                ).expand(),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      EditProfileScreen().launch(context),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 12, bottom: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).dividerColor)),
                                  child: Text(
                                      appLocalization!.translate('login'),
                                      style: boldTextStyle()),
                                ).onTap(() async {
                                  await LoginScreen(isNewTask: false)
                                      .launch(context);
                                  setState(() {});
                                }),
                                if (enableSocialLogin)
                                  SocialLoginWidget(
                                      voidCallback: () => setState(() {})),
                              ],
                            ),
                    ),
                    Divider(
                        height: 20,
                        color: appStore.isDarkMode
                            ? Colors.transparent
                            : Theme.of(context).dividerColor),
                    8.height,
                    titleWidget(appLocalization!.translate('app_settings')),
                    //Commented It
                    // LanguageSelectionWidget(),
                    SettingItemWidget(
                      leading: Icon(MaterialCommunityIcons.theme_light_dark),
                      title: '${appLocalization.translate('select_theme')}',
                      subTitle: appLocalization.translate('choose_app_theme'),
                      onTap: () async {
                        await showInDialog(
                          context,
                          builder: (context) => ThemeSelectionDialog(),
                          contentPadding: EdgeInsets.zero,
                          title: Text(appLocalization.translate('select_theme'),
                              style: boldTextStyle(size: 20)),
                        );
                        if (isIos) {
                          DashboardScreen().launch(context, isNewTask: true);
                        }
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(appStore.isNotificationOn
                          ? Feather.bell
                          : Feather.bell_off),
                      title:
                          '${appStore.isNotificationOn ? appLocalization.translate('disable') : appLocalization.translate('enable')} ${appLocalization.translate(
                        'push_notification',
                      )}',
                      subTitle:
                          appLocalization.translate('enable_push_notification'),
                      trailing: CupertinoSwitch(
                        activeColor: colorPrimary,
                        value: appStore.isNotificationOn,
                        onChanged: (v) {
                          appStore.setNotification(v);
                        },
                      ).withHeight(10),
                      onTap: () {
                        appStore.setNotification(!getBoolAsync(
                            IS_NOTIFICATION_ON,
                            defaultValue: true));
                      },
                    ),
                    SettingItemWidget(
                      leading: Icon(FontAwesome.font),
                      title: appLocalization.translate('article_font_size'),
                      subTitle:
                          appLocalization.translate('choose_article_size'),
                      trailing: DropdownButton<FontSizeModel>(
                        items: fontSizes.map((e) {
                          return DropdownMenuItem<FontSizeModel>(
                              child: Text('${e.title}',
                                  style: primaryTextStyle(size: 14)),
                              value: e);
                        }).toList(),
                        dropdownColor: appStore.isDarkMode
                            ? scaffoldSecondaryDark
                            : Colors.white,
                        value: fontSize,
                        underline: SizedBox(),
                        onChanged: (FontSizeModel? v) async {
                          hideKeyboard(context);

                          await setValue(FONT_SIZE_PREF, v!.fontSize);

                          fontSize = fontSizes.firstWhere((element) =>
                              element.fontSize ==
                              getIntAsync(FONT_SIZE_PREF, defaultValue: 16));

                          setState(() {});
                        },
                      ),
                      onTap: () {
                        //
                      },
                    ),
                    SettingItemWidget(
                      leading: Image.asset('assets/tts.png',
                          width: 25,
                          height: 25,
                          color: appStore.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      title: appLocalization.translate('text_to_speech'),
                      subTitle:
                          appLocalization.translate('select_tts_language'),
                      trailing: DropdownButton<Language>(
                        items: ttsLanguage.map((e) {
                          return DropdownMenuItem<Language>(
                            child: Text('${e.name}',
                                style: primaryTextStyle(size: 14),
                                overflow: TextOverflow.ellipsis),
                            value: e,
                          );
                        }).toList(),
                        dropdownColor: appStore.isDarkMode
                            ? scaffoldSecondaryDark
                            : Colors.white,
                        value: ttsLang,
                        underline: SizedBox(),
                        onChanged: (Language? l) async {
                          appStore.setTTSLanguage(l!.fullLanguageCode);

                          ttsLang = l;

                          setState(() {});
                          toast(
                              '${l.name} ${appLocalization.translate('tts_language_confirm')}');
                        },
                      ),
                      onTap: null,
                    ),
                    16.height,
                    titleWidget(appLocalization.translate('other')),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.lock_outline_rounded),
                      title: appLocalization.translate('change_Pwd'),
                      onTap: () {
                        ChangePasswordScreen().launch(context);
                      },
                    ).visible(appStore.isLoggedIn &&
                        !isLoggedInWithGoogleOrApple() &&
                        getStringAsync(LOGIN_TYPE) != LoginTypeOTP),
                    8.height.visible(appStore.isLoggedIn &&
                        !isLoggedInWithGoogleOrApple() &&
                        getStringAsync(LOGIN_TYPE) != LoginTypeOTP),
                    SettingItemWidget(
                      leading: Icon(Icons.my_library_add_outlined),
                      title: appLocalization.translate('my_Topics'),
                      onTap: () {
                        if (appStore.isLoggedIn) {
                          ChooseTopicScreen().launch(context);
                        } else {
                          LoginScreen().launch(context);
                        }
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.check_circle_outline_outlined),
                      title: appLocalization
                          .translate('choose_dashboard_page_variant'),
                      onTap: () {
                        ChooseDashboardPageVariant().launch(context);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.check_circle_outline_outlined),
                      title: appLocalization
                          .translate('choose_detail_page_variant'),
                      onTap: () {
                        ChooseDetailPageVariantScreen().launch(context);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(FontAwesome.bookmark_o),
                      title: appLocalization.translate('bookmarks'),
                      onTap: () {
                        if (appStore.isLoggedIn) {
                          BookmarkNewsScreen().launch(context);
                        } else {
                          LoginScreen().launch(context);
                        }
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.share_outlined),
                      title:
                          '${appLocalization.translate('share')} Capital View',
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          String package = '';
                          if (isAndroid) package = value.packageName;

                          Share.share(
                              'Share $mAppName app\n\n${storeBaseURL()}$package');
                        });
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.rate_review_outlined),
                      title: appLocalization.translate('rate_us'),
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          String package = '';
                          if (isAndroid) package = value.packageName;

                          launchUrl('${storeBaseURL()}$package');
                        });
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.assignment_outlined),
                      title: appLocalization.translate('term_condition'),
                      onTap: () {
                        launchUrl(getStringAsync(TERMS_AND_CONDITION_PREF),
                            forceWebView: true);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.assignment_outlined),
                      title: appLocalization.translate('privacyPolicy'),
                      onTap: () {
                        launchUrl('https://capitalview.today/privacy-policy/',
                            forceWebView: true);
                      },
                    ),
                    8.height,
                    /*SettingItemWidget(
                      leading: Icon(Icons.support_rounded),
                      title: appLocalization.translate('help_Support'),
                      onTap: () {
                        launchUrl(supportURL, forceWebView: true);
                      },
                    ),
                    8.height,*/
                    SettingItemWidget(
                      leading: Icon(Icons.info_outline),
                      title: appLocalization.translate('about'),
                      onTap: () {
                        AboutAppScreen().launch(context);
                      },
                    ),
                    8.height,
                    SettingItemWidget(
                      leading: Icon(Icons.exit_to_app_rounded),
                      title: appLocalization.translate('logout'),
                      onTap: () async {
                        bool? res = await showConfirmDialog(
                          context,
                          appLocalization.translate('logout_confirmation'),
                          positiveText: appLocalization.translate('yes'),
                          negativeText: appLocalization.translate('no'),
                        );

                        if (res ?? false) {
                          logout(context);
                        }
                      },
                    ).visible(appStore.isLoggedIn),
                    8.height,
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snap) {
                        if (snap.hasData) {
                          return Text(
                                  '${appLocalization.translate('version')} ${snap.data!.version.validate()}',
                                  style: secondaryTextStyle(size: 10))
                              .paddingLeft(16);
                        }
                        return SizedBox();
                      },
                    ),
                    20.height,
                  ],
                ),
              ),
              Loader().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
