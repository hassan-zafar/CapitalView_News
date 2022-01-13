import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news/network/AuthService.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'OTPDialog.dart';

class SocialLoginWidget extends StatelessWidget {
  static String tag = '/SocialLoginWidget';
  final VoidCallback? voidCallback;

  SocialLoginWidget({this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  appStore.isDarkMode ? Colors.white12 : Colors.grey.shade100),
          child: IconButton(
            icon: Image.asset('assets/ic_google.png', height: 30),
            onPressed: () async {
              hideKeyboard(context);

              appStore.setLoading(true);

              await signInWithGoogle().then((user) {
                //DashboardScreen().launch(context, isNewTask: true);

                voidCallback?.call();
              }).catchError((e) {
                toast(e.toString());
              });

              appStore.setLoading(false);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 4),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appStore.isDarkMode ? Colors.white12 : Colors.black),
          child: IconButton(
            icon: Image.asset('assets/ic_apple.png', color: white),
            onPressed: () async {
              hideKeyboard(context);

              appStore.setLoading(true);

              await appleLogIn().then((value) {
                //DashboardScreen().launch(context, isNewTask: true);

                voidCallback?.call();
              }).catchError((e) {
                toast(e.toString());
              });

              appStore.setLoading(false);
            },
          ),
        ).visible(isIos),
        //TODO:Commented it

        // Container(
        //   margin: EdgeInsets.only(left: 4),
        //   padding: EdgeInsets.all(2),
        //   decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkMode ? Colors.white12 : Colors.grey.shade100),
        //   child: IconButton(
        //     icon: Icon(Feather.phone, color: Colors.blue),
        //     onPressed: () async {
        //       hideKeyboard(context);

        //       appStore.setLoading(true);

        //       await showInDialog(context, builder: (context) => OTPDialog(), barrierDismissible: false).catchError((e) {
        //         toast(e.toString());
        //       });

        //       appStore.setLoading(false);
        //       voidCallback?.call();
        //     },
        //   ),
        // ),
      ],
    );
  }
}
