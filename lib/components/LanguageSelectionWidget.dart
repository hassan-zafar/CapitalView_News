import 'package:flutter/material.dart';
import 'package:mighty_news/models/LanguageModel.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class LanguageSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SettingItemWidget(
      leading: Image.asset(language!.flag, height: 24),
      title: appLocalization.translate('language'),
      subTitle: appLocalization.translate('choose_app_language'),
      onTap: () async {
        hideKeyboard(context);
      },
      trailing: DropdownButton(
        items: languages.map((e) => DropdownMenuItem<Language>(child: Text(e.name, style: primaryTextStyle(size: 14)), value: e)).toList(),
        dropdownColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
        value: language,
        underline: SizedBox(),
        onChanged: (Language? v) async {
          hideKeyboard(context);
          appStore.setLanguage(v!.languageCode, context: context);
        },
      ),
    );
  }
}
