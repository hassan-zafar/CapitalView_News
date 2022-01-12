import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/ForgotPasswordDialog.dart';
import 'package:mighty_news/components/LanguageSelectionWidget.dart';
import 'package:mighty_news/components/SocialLoginWidget.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/RegisterScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'DashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  /// Should not launch LoginScreen with isNewTask true
  final bool? isNewTask;

  LoginScreen({this.isNewTask});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool passwordVisible = false;

  bool isRemembered = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (!getBoolAsync(IS_SOCIAL_LOGIN) && getStringAsync(LOGIN_TYPE) != LoginTypeOTP && !getBoolAsync(IS_REMEMBERED)) {
      emailController.text = getStringAsync(USER_EMAIL);
      passwordController.text = getStringAsync(PASSWORD);
    }
    if (isIos) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }
    setState(() {});

    setDynamicStatusBarColor();
  }

  Future<void> signIn() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map req = {
        'username': emailController.text,
        'password': passwordController.text,
      };

      await login(req).then((value) async {
        appStore.setLoading(false);

        if (widget.isNewTask.validate()) {
          DashboardScreen().launch(context, isNewTask: true);
        } else {
          finish(context, true);
        }
      }).catchError((e) {
        appStore.setLoading(false);

        toast(e.toString());
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/app_logo.png', height: 100),
                    16.height,
                    Text(appLocalization.translate('login_Title'), style: boldTextStyle(size: 22)),
                    20.height,
                    AppTextField(
                      controller: emailController,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, hint: appLocalization.translate('email')),
                      errorInvalidEmail: appLocalization.translate('email_Validation'),
                      nextFocus: passFocus,
                    ),
                    8.height,
                    AppTextField(
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      decoration: inputDecoration(context, hint: appLocalization.translate('password')),
                      errorMinimumPasswordLength: appLocalization.translate('password_length'),
                      onFieldSubmitted: (s) {
                        signIn();
                      },
                    ),
                    8.height,
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: getBoolAsync(IS_REMEMBERED, defaultValue: true),
                              onChanged: (v) async {
                                await setValue(IS_REMEMBERED, v);
                                setState(() {});
                              },
                            ),
                            Text(appLocalization.translate('remember_me'), style: primaryTextStyle()).onTap(() async {
                              await setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                              setState(() {});
                            }).expand(),
                          ],
                        ).expand(),
                        Text(appLocalization.translate('forgot_pwd'), style: primaryTextStyle()).paddingAll(8).onTap(() async {
                          hideKeyboard(context);
                          await showInDialog(context, builder: (context) => ForgotPasswordDialog());
                        }),
                      ],
                    ),
                    8.height,
                    AppButton(
                      text: appLocalization.translate('login'),
                      textStyle: boldTextStyle(color: white),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                      onTap: () {
                        signIn();
                      },
                      width: context.width(),
                    ),
                    16.height,
                    AppButton(
                      text: appLocalization.translate('signUp'),
                      textStyle: boldTextStyle(color: textPrimaryColorGlobal),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : white,
                      width: context.width(),
                      onTap: () {
                        hideKeyboard(context);
                        RegisterScreen().launch(context);
                      },
                    ),
                    16.height,
                    if (enableSocialLogin)
                      SocialLoginWidget(voidCallback: () {
                        DashboardScreen().launch(context, isNewTask: true);
                      }),
                    LanguageSelectionWidget(),
                  ],
                ),
              ),
            ).center(),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            BackButton().paddingTop(30),
          ],
        ),
      ),
    );
  }
}
