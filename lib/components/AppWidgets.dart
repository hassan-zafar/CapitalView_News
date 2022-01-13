import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mighty_news/AppLocalizations.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget noDataWidget(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('assets/no_data.png', height: 80, fit: BoxFit.fitHeight),
      8.height,
      Text(AppLocalizations.of(context)!.translate('no_data'), style: boldTextStyle()).center(),
    ],
  ).center();
}

void openPhotoViewer(BuildContext context, ImageProvider imageProvider) {
  Scaffold(
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
        Positioned(top: 35, left: 16, child: BackButton(color: Colors.white)),
      ],
    ),
  ).launch(context);
}

Widget getPostCategoryTagWidget(BuildContext context, NewsData newsData) {
  return Scrollbar(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: newsData.category
            .validate()
            .map((e) {
              return Container(
                padding: EdgeInsets.only(right: 8, top: 4, bottom: 4, left: 8),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(color: colorPrimary, borderRadius: radius()),
                child: Row(
                  children: [
                    //if (e.image.validate().isNotEmpty) cachedImage(e.image, height: 20, width: 20, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius).paddingSymmetric(horizontal: 8),
                    Text('${e.name.validate()}', style: boldTextStyle(size: 12, color: Colors.white)),
                  ],
                ),
              );
            })
            .take(1)
            .toList(),
      ),
    ),
  );
}
