import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news/components/CategoryItemWidget.dart';
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/SubCategoryScreen.dart';
import 'package:mighty_news/shimmer/TopicShimmer.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class CategoryFragment extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryFragmentState createState() => CategoryFragmentState();
}

class CategoryFragmentState extends State<CategoryFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalization.translate('category'), style: boldTextStyle()),
          ],
        ).paddingSymmetric(vertical: 20, horizontal: 16),
        SingleChildScrollView(
          child: FutureBuilder<List<CategoryData>>(
            initialData: getStringAsync(CATEGORY_DATA).isEmpty ? null : getInitialData(),
            future: getCategories(),
            builder: (_, snap) {
              if (snap.hasData) {
                setValue(CATEGORY_DATA, jsonEncode(snap.data));

                return Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: snap.data!.map((data) {
                    return CategoryItemWidget(data, onTap: () {
                      SubCategoryScreen(data, snap.hasError).launch(context);
                    });
                  }).toList(),
                ).paddingAll(4);
              }
              return snapWidgetHelper(snap, loadingWidget: TopicShimmer());
            },
          ),
        ).expand(),
      ],
    );
  }
}
