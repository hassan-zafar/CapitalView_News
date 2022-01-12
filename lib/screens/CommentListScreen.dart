import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/PostCommentDialog.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/CommentData.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/LoginScreen.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentListScreen extends StatefulWidget {
  static String tag = '/CommentListScreen';
  final int? id;

  CommentListScreen(this.id);

  @override
  CommentListScreenState createState() => CommentListScreenState();
}

class CommentListScreenState extends State<CommentListScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor(milliseconds: 400);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget getAuthorImage(CommentData data) {
      if (data.author_avatar_urls != null && data.author_avatar_urls!.url.validate().isNotEmpty) {
        log('1 ${data.author_avatar_urls!.url.validate()}');
        return cachedImage(data.author_avatar_urls!.url!,fit: BoxFit.cover).cornerRadiusWithClipRRect(20);
      } else if (data.author_name.validate().isNotEmpty) {
        log('2');
        return Text(data.author_name!.substring(0, 1).toUpperCase(), style: boldTextStyle(color: Colors.white, size: 22)).center();
      } else {
        return SizedBox();
      }
    }

    return SafeArea(
        top: !isIos ? true : false,
        child: Scaffold(
          appBar: appBarWidget(
            appLocalization!.translate('Comments'),
            showBack: true,
            color: getAppBarWidgetBackGroundColor(),
            textColor: getAppBarWidgetTextColor(),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1 || appStore.isDarkMode ? Colors.white : Colors.black,
                onPressed: () async {
                  if (appStore.isLoggedIn) {
                    bool? res = await showInDialog(context, builder: (context) => PostCommentDialog(widget.id));

                    if (res ?? false) {
                      setState(() {});
                    }
                  } else {
                    LoginScreen(isNewTask: false).launch(context);
                  }
                },
              ),
            ],
          ),
          body: Container(
            height: context.height(),
            width: context.width(),
            child: Stack(
              children: [
                FutureBuilder<List<CommentData>>(
                  future: getCommentList(widget.id),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      if (snap.data!.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: !getBoolAsync(DISABLE_AD) ? 50 : 0),
                          child: ListView.separated(
                            itemCount: snap.data!.length,
                            padding: EdgeInsets.all(16.0),
                            shrinkWrap: true,
                            separatorBuilder: (_, index) => SizedBox(height: 8),
                            itemBuilder: (_, index) {
                              CommentData data = snap.data![index];
                              return data.isMyComment
                                  ? Dismissible(
                                      background: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          height: context.height(),
                                          width: context.width() * 0.30,
                                          color: appStore.isDarkMode ? Theme.of(context).cardColor : colorPrimary,
                                          child: Icon(Icons.delete, color: white).onTap(() {}),
                                        ),
                                      ),
                                      onDismissed: (DismissDirection direction) {
                                        snap.data!.removeAt(index);
                                      },
                                      key: ValueKey(snap.data![index]),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: getAppPrimaryColor()),
                                              child: getAuthorImage(data),
                                              padding: EdgeInsets.all(14),
                                            ),
                                            16.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(parseHtmlString(data.author_name.validate().removeAllWhiteSpace()), style: secondaryTextStyle()),
                                                Text(parseHtmlString(data.content!.rendered.validate()), style: primaryTextStyle()),
                                              ],
                                            ).expand(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(appLocalization.translate('swipe_right_to_delete'), style: secondaryTextStyle(size: 8)).visible(data.isMyComment),
                                                8.height,
                                                Text(DateFormat('dd MMM, yyyy  HH:mm').format(DateTime.parse(data.date.validate())), style: secondaryTextStyle(size: 10)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      confirmDismiss: (DismissDirection direction) async {
                                        return showConfirmDialog(
                                          context,
                                          appLocalization.translate('delete_dialog'),
                                          positiveText: appLocalization.translate('yes'),
                                          negativeText: appLocalization.translate('no'),
                                          onAccept: () {
                                            if (getBoolAsync(IS_LOGGED_IN)) {
                                              if (data.isMyComment) {
                                                removeComment(id: data.id);
                                              }
                                            } else {
                                              toast(appLocalization.translate('please_log_in'));
                                            }
                                          },
                                        );
                                      },
                                    )
                                  :  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(shape: BoxShape.circle,  color: context.cardColor),
                                    child: getAuthorImage(data),
                                  ),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(parseHtmlString(data.author_name.validate().removeAllWhiteSpace()), style: secondaryTextStyle()),
                                      Text(parseHtmlString(data.content!.rendered.validate()), style: primaryTextStyle()),
                                    ],
                                  ).expand(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(appLocalization.translate('swipe_right_to_delete'), style: secondaryTextStyle(size: 8)).visible(data.isMyComment),
                                      8.height,
                                      Text(DateFormat('dd MMM, yyyy  HH:mm').format(DateTime.parse(data.date.validate())), style: secondaryTextStyle(size: 10)),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return noDataWidget(context);
                      }
                    }

                    return snapWidgetHelper(snap);
                  },
                ),
                Loader().visible(appStore.isLoading),
              ],
            ),
          ),
        ),
 
    );
  }
}
