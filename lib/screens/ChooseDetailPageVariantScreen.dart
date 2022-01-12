import 'package:flutter/material.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ChooseDetailPageVariantScreen extends StatefulWidget {
  static String tag = '/ChooseDetailPageVariantScreen';

  @override
  ChooseDetailPageVariantScreenState createState() => ChooseDetailPageVariantScreenState();
}

class ChooseDetailPageVariantScreenState extends State<ChooseDetailPageVariantScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos ? true : false,
      child: Scaffold(
        appBar: appBarWidget(appLocale.translate('choose_detail_page_variant'), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                itemWidget(
                  title: '${appLocale.translate('variant')} 1',
                  code: 1,
                  onTap: () {
                    setValue(DETAIL_PAGE_VARIANT, 1);
                    setState(() {});
                  },
                ),
                itemWidget(
                  title: '${appLocale.translate('variant')} 2',
                  code: 2,
                  onTap: () {
                    setValue(DETAIL_PAGE_VARIANT, 2);
                    setState(() {});
                  },
                ),
                itemWidget(
                  title: '${appLocale.translate('variant')} 3',
                  code: 3,
                  onTap: () {
                    setValue(DETAIL_PAGE_VARIANT, 3);
                    setState(() {});
                  },
                ),
              ],
            ).center(),
          ),
        ),
      ),
    );
  }

  Widget itemWidget({required Function onTap, String? title, int code = 1, String? img}) {
    return Container(
      width: context.width() * 0.48,
      height: context.height() * 0.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code ? colorPrimary : Theme.of(context).dividerColor,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img_variant_$code.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code ? Colors.black12 : Colors.black45,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            child: Text(title.validate(), style: boldTextStyle(color: textPrimaryColor)),
            decoration: BoxDecoration(color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code ? Colors.white : Colors.white54, borderRadius: radius(defaultRadius)),
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          ).center(),
          Positioned(
            bottom: 8,
            right: 8,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.check, size: 18, color: colorPrimary),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: defaultBoxShadow()),
            ).visible(getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code),
          ),
        ],
      ),
    ).onTap(() {
      onTap.call();

      if (appStore.isLoggedIn) {
        updateProfile(showToast: false).then((value) {
          //
        }).catchError((e) {
          log(e);
        });
      }
    });
  }
}
