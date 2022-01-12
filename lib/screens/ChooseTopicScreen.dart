import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/CategoryItemWidget.dart';
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/shimmer/TopicShimmer.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class ChooseTopicScreen extends StatefulWidget {
  static String tag = '/ChooseTopicScreen';

  @override
  ChooseTopicScreenState createState() => ChooseTopicScreenState();
}

class ChooseTopicScreenState extends State<ChooseTopicScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setDynamicStatusBarColor();
  }

  Future<void> save() async {
    hideKeyboard(context);

    if (appStore.isLoggedIn) {
      appStore.isLoading = true;
      setState(() {});

      bool? res = await updateProfile(toastMessage: 'Saved');

      appStore.isLoading = false;
      setState(() {});

      if ((res ?? false) && mounted) finish(context, true);
    }
  }

  List<CategoryData> getInitialData() {
    List<CategoryData> list = [];
    String s = getStringAsync(CATEGORY_DATA);

    if (s.isNotEmpty) {
      Iterable it = jsonDecode(s);
      list.addAll(it.map((e) => CategoryData.fromJson(e)).toList());
    }

    return list;
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
        appBar: appBarWidget(
          appLocalization.translate('choose_Topics'),
          showBack: true,
          color: getAppBarWidgetBackGroundColor(),
          textColor: getAppBarWidgetTextColor(),
          actions: [
            IconButton(icon: Icon(Icons.check, color: white), onPressed: () => save()),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<List<CategoryData>>(
              initialData: getStringAsync(CATEGORY_DATA).isEmpty ? null : getInitialData(),
              future: getCategories(),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(top: 8),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: snap.data!.map((data) {
                          return CategoryItemWidget(data);
                        }).toList(),
                      ).paddingAll(4),
                    );
                  } else {
                    return noDataWidget(context);
                  }
                }

                return snapWidgetHelper(
                  snap,
                  loadingWidget: TopicShimmer(),
                );
              },
            ),
           Loader().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}
