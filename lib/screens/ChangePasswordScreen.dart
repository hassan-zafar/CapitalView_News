import 'package:flutter/material.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  var oldPassCont = TextEditingController();
  var newPassCont = TextEditingController();
  var confNewPassCont = TextEditingController();

  var newPassFocus = FocusNode();
  var confPassFocus = FocusNode();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confPasswordVisible = false;

  bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setDynamicStatusBarColor();
  }

  submit() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassCont.text.trim(),
        'new_password': newPassCont.text.trim(),
      };

      mIsLoading = true;
      setState(() {});

      await changePassword(req).then((value) async {
        await setValue(PASSWORD, newPassCont.text.trim());

        finish(context);
        toast(value.message.validate());
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() {
        mIsLoading = false;
        setState(() {});
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIos ? true : false,
      child: Scaffold(
        appBar: appBarWidget(appLocalization.translate('change_Pwd'), showBack: true, elevation: 0, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: oldPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, hint: appLocalization.translate('password')),
                        nextFocus: newPassFocus,
                        textStyle: primaryTextStyle(),
                      ),
                      16.height,
                      AppTextField(
                        controller: newPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, hint: appLocalization.translate('new_password')),
                        focus: newPassFocus,
                        nextFocus: confPassFocus,
                        textStyle: primaryTextStyle(),
                      ),
                      16.height,
                      AppTextField(
                        controller: confNewPassCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, hint: appLocalization.translate('confirm_Password')),
                        focus: confPassFocus,
                        validator: (String? value) {
                          if (value!.isEmpty) return errorThisFieldRequired;
                          if (value.length < passwordLengthGlobal) return passwordLengthMsg;
                          if (value.trim() != newPassCont.text.trim()) return appLocalization.translate('confirmPwdValidation');
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (s) {
                          submit();
                        },
                        textStyle: primaryTextStyle(),
                      ),
                      30.height,
                      AppButton(
                        onTap: () {
                          submit();
                        },
                        text: appLocalization.translate('save'),
                        width: context.width(),
                        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              Loader().withSize(height: 40, width: 40).center().visible(mIsLoading),
            ],
          ),
        ),
      ),
    );
  }
}
