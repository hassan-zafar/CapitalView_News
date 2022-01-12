import 'package:flutter/material.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ForgotPasswordDialog extends StatefulWidget {
  static String tag = '/ForgotPasswordDialog';

  @override
  ForgotPasswordDialogState createState() => ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController emailCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> submit(AppLocalizations appLocale) async {
    if (emailCont.text.trim().isEmpty) return toast(errorThisFieldRequired);

    if (!emailCont.text.trim().validateEmail()) return toast(appLocale.translate('email_is_invalid'));

    hideKeyboard(context);

    Map req = {
      'email': emailCont.text.trim(),
    };

    await forgotPassword(req).then((value) {
      toast(value.message);
      finish(context);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appLocalization.translate('forgot_pwd'), style: boldTextStyle()),
              CloseButton(),
            ],
          ),
          8.height,
          AppTextField(
            controller: emailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(context, hint: appLocalization.translate('email')),
            textStyle: primaryTextStyle(),
            autoFocus: true,
          ),
          30.height,
          AppButton(
            text: appLocalization.translate('submit'),
            color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
            textStyle: boldTextStyle(color: white),
            onTap: () {
              submit(appLocalization);
            },
            width: context.width(),
          ),
        ],
      ),
    );
  }
}
