import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentTextWidget extends StatelessWidget {
  static String tag = '/CommentText';
  final int? value;
  final String? text;
  final Color? textColor;
  final int? textSize;

  CommentTextWidget({this.value, this.textColor, this.text,this.textSize});

  @override
  Widget build(BuildContext context) {
    return Text(text.validate(), style: secondaryTextStyle(color: textColor,size:textSize!=null? textSize: 14));
  }
}
