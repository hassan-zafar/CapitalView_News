import 'package:flutter/material.dart';
import 'package:mighty_news/components/AppWidgets.dart';
import 'package:mighty_news/components/PaginatedNewsWidget.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class SubCategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';
  final CategoryData categoryData;
  final hasError;

  SubCategoryScreen(this.categoryData, this.hasError);

  @override
  SubCategoryScreenState createState() => SubCategoryScreenState();
}

class SubCategoryScreenState extends State<SubCategoryScreen> {
  int? categoryId = 0;
  int page = 1;

  List<CategoryData> categories = [];

  @override
  void initState() {
    super.initState();
    init();

    setDynamicStatusBarColor();
  }

  Future<void> init() async {
    appStore.setLoading(true);

    getCategories(parent: widget.categoryData.cat_ID).then((value) {
      appStore.setLoading(false);
      categories.addAll(value);

      categoryId = widget.categoryData.cat_ID;

      setState(() {});
    }).catchError((e) {
      categoryId = -1;

      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !isIos ? true : false,
      child: Scaffold(
        appBar: appBarWidget(widget.categoryData.name!, showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              categoryId.validate() != 0
                  ? PaginatedNewsWidget(
                      {
                        if (categoryId == widget.categoryData.cat_ID) 'category': categoryId,
                        if (categoryId != widget.categoryData.cat_ID) 'subcategory': categoryId,
                        'filter': 'by_category',
                        'posts_per_page': postsPerPage,
                      },
                      topPadding: categories.isEmpty ? 0 : 70,
                      usePreFetch: false,
                    )
                  : SizedBox(),
              Container(
                height: categories.isEmpty ? 0 : 70,
                width: context.width(),
                color: context.scaffoldBackgroundColor,
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: EdgeInsets.all(8),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    CategoryData data = categories[index];

                    return Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      margin: EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: data.cat_ID == categoryId ? colorPrimary : context.cardColor,blurRadius: 1),
                      alignment: Alignment.center,
                      child: Text(data.name.validate(), style: boldTextStyle(color: data.cat_ID == categoryId ? Colors.white : colorPrimary)),
                    ).onTap(() {
                      categoryId = data.cat_ID;
                      appStore.setLoading(true);

                      setState(() {});
                    });
                  },
                ),
              ),
              Loader().visible(appStore.isLoading),
              noDataWidget(context).visible(categories.isEmpty && !appStore.isLoading && categoryId == 0),
            ],
          ),
        ),
      ),
    );
  }
}
