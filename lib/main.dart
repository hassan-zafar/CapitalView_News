import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/AppTheme.dart';
import 'package:mighty_news/models/FontSizeModel.dart';
import 'package:mighty_news/screens/SplashScreen.dart';
import 'package:mighty_news/store/AppStore.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'models/LanguageModel.dart';
import 'models/WeatherResponse.dart';

AppStore appStore = AppStore();

int mAdShowCount = 0;

Language? language;
List<Language> languages = Language.getLanguages();

FontSizeModel? fontSize;
List<FontSizeModel> fontSizes = FontSizeModel.fontSizes();

Language? ttsLang;
List<Language> ttsLanguage = Language.getLanguagesForTTS();

var weatherMemoizer = AsyncMemoizer<WeatherResponse>();

RemoteConfig? remoteConfig;
int retryCount = 0;

AppLocalizations? appLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultRadius = 10;
  defaultAppButtonRadius = 30;
  defaultBlurRadius = 4.0;
  defaultLoaderAccentColorGlobal = colorPrimary;

  await initialize(defaultDialogBorderRadius: 10);

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));
  appStore.setTTSLanguage(getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));

  ///Uncomment below line if you want to skip https certificate
  //HttpOverrides.global = HttpOverridesSkipCertificate();

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));
  // ttsLang = ttsLanguage.firstWhere((element) => element.fullLanguageCode == getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));

  if (isMobile) {
    await Firebase.initializeApp().then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      MobileAds.instance.initialize();
    });

    await OneSignal.shared.setAppId(mOneSignalAPPKey);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();

    // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  setOrientationPortrait();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        navigatorKey: navigatorKey,
        title: mAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        supportedLocales: Language.languagesLocale(),
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        home: SplashScreen(),
        scrollBehavior: SBehavior(),
      ),
    );
  }
}
