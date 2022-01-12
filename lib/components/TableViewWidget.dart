import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';

class TableViewWidget extends StatelessWidget {
  final RenderContext? renderContext;

  TableViewWidget(this.renderContext);

  @override
  Widget build(BuildContext context) {
    setOrientationLandscape();
    return Scaffold(
      appBar: appBarWidget(''),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
            scrollDirection: Axis.horizontal,
            child: (renderContext!.tree as TableLayoutElement).toWidget(renderContext!),
          ),
        ).center(),
      ),
    );
  }
}
