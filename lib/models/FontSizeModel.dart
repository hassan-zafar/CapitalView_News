class FontSizeModel {
  String? title;
  int? fontSize;

  FontSizeModel({this.title, this.fontSize});

  static List<FontSizeModel> fontSizes() {
    List<FontSizeModel> list = [];

    list.add(FontSizeModel(fontSize: 12, title: 'Small'));
    list.add(FontSizeModel(fontSize: 16, title: 'Medium'));
    list.add(FontSizeModel(fontSize: 18, title: 'Normal'));
    list.add(FontSizeModel(fontSize: 24, title: 'Large'));
    list.add(FontSizeModel(fontSize: 30, title: 'Extra Large'));

    return list;
  }
}
