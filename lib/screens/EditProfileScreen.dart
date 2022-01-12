import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool passwordVisible = false;

  bool isLoading = false;

  PickedFile? image;

  @override
  void initState() {
    super.initState();
    init();

    setDynamicStatusBarColor();
  }

  Future<void> init() async {
    firstNameController.text = getStringAsync(FIRST_NAME);
    lastNameController.text = getStringAsync(LAST_NAME);
  }

  Future save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      isLoading = true;
      setState(() {});

      bool? res = await updateProfile(firstName: firstNameController.text, lastName: lastNameController.text, file: image != null ? File(image!.path) : null);

      isLoading = false;
      setState(() {});

      if (res ?? false) finish(context);
    }
  }

  Future getImage() async {
    if (!isLoggedInWithGoogleOrApple()) {
      image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget profileImage() {
      if (image != null) {
        return Image.file(File(image!.path), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
      } else {
        if (getStringAsync(LOGIN_TYPE) == LoginTypeGoogle || getStringAsync(LOGIN_TYPE) == LoginTypeApp) {
          return cachedImage(appStore.userProfileImage, height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
        } else {
          return Icon(Icons.person_outline_rounded).paddingAll(16);
        }
      }
    }

    return SafeArea(
      top: !Platform.isIOS ? true : false,
      child: Scaffold(
        appBar: appBarWidget(appLocalization.translate('edit_Profile'), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 16,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                              child: profileImage(),
                            ),
                            Text(
                              appLocalization.translate('change_avatar'),
                              style: boldTextStyle(),
                            ).paddingTop(16).visible(!isLoggedInWithGoogleOrApple()),
                          ],
                        ).paddingOnly(top: 16, bottom: 16),
                      ).onTap(() {
                        getImage();
                      }),
                      16.height,
                      AppTextField(
                        controller: firstNameController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(context, hint: appLocalization.translate('first_Name')),
                        nextFocus: lastNameFocus,
                        textStyle: primaryTextStyle(),
                      ),
                      8.height,
                      AppTextField(
                        controller: lastNameController,
                        focus: lastNameFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(context, hint: appLocalization.translate('last_Name')),
                        onFieldSubmitted: (s) {
                          save();
                        },
                        textStyle: primaryTextStyle(),
                      ),
                      30.height,
                      AppButton(
                        text: appLocalization.translate('save'),
                        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                        onTap: () {
                          save();
                        },
                        width: context.width(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Loader().center().visible(isLoading),
          ],
        ),
      ),
    );
  }
}
