import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ListViewStateBuilder extends StatefulWidget {
  final Widget? listView;
  final int length;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? loaderWidget;
  final bool? hasError;

  ListViewStateBuilder({required this.length, this.listView, this.emptyWidget, this.errorWidget, this.hasError, this.loaderWidget});

  @override
  _ListViewStateBuilderState createState() => _ListViewStateBuilderState();
}

class _ListViewStateBuilderState extends State<ListViewStateBuilder> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError.validate()) {
      return widget.errorWidget.validate();
    } else {
      return Stack(
        children: [
          widget.length == 0 ? widget.emptyWidget.center() : widget.listView!,
          widget.loaderWidget.validate(),
        ],
      );
    }
  }
}
