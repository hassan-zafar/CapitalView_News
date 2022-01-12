import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:mighty_news/components/AudioPostWidget.dart';
import 'package:mighty_news/components/PdfViewWidget.dart';
import 'package:mighty_news/components/TableViewWidget.dart';
import 'package:mighty_news/components/VimeoEmbedWidget.dart';
import 'package:mighty_news/components/YouTubeEmbedWidget.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';
import 'TweetWidget.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent!,
      onLinkTap: (s, _, __, ___) {
        if (s!.split('/').last.contains('.pdf')) {
          PdfViewWidget(pdfUrl: s).launch(context);
        } else {
          launchUrl(s, forceWebView: true);
        }
      },
      onImageTap: (s, _, __, ___) {
        openPhotoViewer(context, Image.network(s!).image);
      },
      style: {
        "table": Style(backgroundColor: color ?? transparentColor),
        "tr": Style(border: Border(bottom: BorderSide(color: Colors.black45.withOpacity(0.5)))),
        "th": Style(padding: EdgeInsets.all(6), backgroundColor: Colors.black45.withOpacity(0.5)),
        "td": Style(padding: EdgeInsets.all(6), alignment: Alignment.center),
        'embed': Style(color: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'strong': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'a': Style(color: color ?? Colors.blue, fontWeight: FontWeight.bold, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'div': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'figure': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()), padding: EdgeInsets.zero, margin: EdgeInsets.zero),
        'h1': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h2': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h3': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h4': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h5': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h6': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'ol': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'ul': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'strike': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'u': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'b': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'i': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'hr': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'header': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'code': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'data': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'body': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'big': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'blockquote': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'audio': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'img': Style(width: context.width(), padding: EdgeInsets.only(bottom: 8), fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'li': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
          listStyleType: ListStyleType.DISC,
          listStylePosition: ListStylePosition.OUTSIDE,
        ),
      },
      customRender: {
        "embed": (RenderContext renderContext, Widget child) {
          var videoLink = renderContext.parser.htmlData.text.splitBetween('<embed>', '</embed');

          if (videoLink.contains('yout')) {
            return YouTubeEmbedWidget(videoLink.replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (videoLink.contains('vimeo')) {
            return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
          } else {
            return child;
          }
        },
        "figure": (RenderContext renderContext, Widget child) {
          if (renderContext.tree.element!.innerHtml.contains('yout')) {
            return YouTubeEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (renderContext.tree.element!.innerHtml.contains('vimeo')) {
            return VimeoEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
          } else if (renderContext.tree.element!.innerHtml.contains('audio')) {
            return AudioPostWidget(postString: renderContext.tree.element!.innerHtml);
          } else {
            return child;
          }
        },
        "iframe": (RenderContext renderContext, Widget child) {
          return YouTubeEmbedWidget(renderContext.tree.attributes['src']!.convertYouTubeUrlToId());
        },
        "img": (RenderContext renderContext, Widget child) {
          String img = '';
          if (renderContext.tree.attributes.containsKey('src')) {
            img = renderContext.tree.attributes['src']!;
          } else if (renderContext.tree.attributes.containsKey('data-src')) {
            img = renderContext.tree.attributes['data-src']!;
          }
          return cachedImage(img).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
            openPhotoViewer(context, NetworkImage(img));
          });
        },
        "blockquote": (RenderContext renderContext, Widget child) {
          return TweetWebView(tweetUrl: renderContext.tree.element!.outerHtml);
        },
        "table": (RenderContext renderContext, Widget child) {
          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.open_in_full_rounded),
                  onPressed: () async {
                    await TableViewWidget(renderContext).launch(context);
                    setOrientationPortrait();
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (renderContext.tree as TableLayoutElement).toWidget(renderContext),
              ),
            ],
          );
        },
      },
    );
  }
}
