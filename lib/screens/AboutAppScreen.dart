import 'package:flutter/material.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class AboutAppScreen extends StatelessWidget {
  static String tag = '/AboutAppScreen';

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos ? true : false,
      child: Scaffold(
        appBar: appBarWidget('About',
            showBack: true,
            color: getAppBarWidgetBackGroundColor(),
            textColor: getAppBarWidgetTextColor()),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mAppName, style: primaryTextStyle(size: 30)),
              16.height,
              Container(
                decoration:
                    BoxDecoration(color: colorPrimary, borderRadius: radius(4)),
                height: 4,
                width: 100,
              ),
              16.height,
              Text(appLocalization.translate('version'),
                  style: secondaryTextStyle()),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('${snap.data!.version.validate()}',
                        style: primaryTextStyle());
                  }
                  return SizedBox();
                },
              ),
              16.height.visible(getStringAsync(LAST_UPDATE_DATE).isNotEmpty),
              Text('Last Update', style: secondaryTextStyle())
                  .visible(getStringAsync(LAST_UPDATE_DATE).isNotEmpty),
              Text(getStringAsync(LAST_UPDATE_DATE), style: primaryTextStyle()),
              16.height.visible(getStringAsync(LAST_UPDATE_DATE).isNotEmpty),
              Text('News Source', style: secondaryTextStyle()),
              Text('Capital View', style: primaryTextStyle()),
              16.height,
              Text(
                '$mAppName app is a smart Flutter news app. It contains Flutter source code and to build your news application with most useful'
                ' features and eye-catching outlook. If you are planning to deploy your news app project for android and ios users, then it’s your'
                ' perfect match to have on your hand.',
                style: primaryTextStyle(size: 14),
                textAlign: TextAlign.justify,
              ),
              Text('Developed By', style: secondaryTextStyle()),
              Text('Hassan Zafar', style: primaryTextStyle()),
              16.height,
              AppButton(
                color:
                    appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.contact_support_outlined, color: Colors.white),
                    8.width,
                    Text('Contact Developer',
                        style: boldTextStyle(color: white)),
                  ],
                ),
                onTap: () {
                  launchUrl('mailto:hz.asd1@gmail.com}');
                },
              ),
              16.height,
              // AppButton(
              //   color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Image.asset('assets/purchase.png', height: 24, color: white),
              //       8.width,
              //       Text('Purchase', style: boldTextStyle(color: white)),
              //     ],
              //   ),
              //   onTap: () {
              //     launchUrl(codeCanyonURL);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
