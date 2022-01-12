class CategoryData {
  Links? links;
  int? count;
  String? description;
  int? id;
  int? cat_ID;
  String? link;
  String? name;
  int? parent;
  String? slug;
  String? taxonomy;

  String? image;

  CategoryData({this.links, this.count, this.cat_ID, this.description, this.id, this.link, this.name, this.parent, this.slug, this.taxonomy, this.image});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      cat_ID: json['cat_ID'],
      count: json['count'],
      description: json['description'],
      id: json['id'],
      link: json['link'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
      taxonomy: json['taxonomy'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['description'] = this.description;
    data['cat_ID'] = this.cat_ID;
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    data['taxonomy'] = this.taxonomy;
    data['image'] = this.image;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  List<About>? about;
  List<Collection>? collection;
  List<Cury>? curies;
  List<Self>? self;
  List<WpPostType>? post_type;

  Links({this.about, this.collection, this.curies, this.self, this.post_type});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      about: json['about'] != null ? (json['about'] as List).map((i) => About.fromJson(i)).toList() : null,
      collection: json['collection'] != null ? (json['collection'] as List).map((i) => Collection.fromJson(i)).toList() : null,
      curies: json['curies'] != null ? (json['curies'] as List).map((i) => Cury.fromJson(i)).toList() : null,
      self: json['self'] != null ? (json['self'] as List).map((i) => Self.fromJson(i)).toList() : null,
      post_type: json['wp:post_type'] != null ? (json['wp:post_type'] as List).map((i) => WpPostType.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.about != null) {
      data['about'] = this.about!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.curies != null) {
      data['curies'] = this.curies!.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.post_type != null) {
      data['wp:post_type'] = this.post_type!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cury {
  String? href;
  String? name;
  bool? templated;

  Cury({this.href, this.name, this.templated});

  factory Cury.fromJson(Map<String, dynamic> json) {
    return Cury(
      href: json['href'],
      name: json['name'],
      templated: json['templated'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['name'] = this.name;
    data['templated'] = this.templated;
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  factory Self.fromJson(Map<String, dynamic> json) {
    return Self(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class Collection {
  String? href;

  Collection({this.href});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class WpPostType {
  String? href;

  WpPostType({this.href});

  factory WpPostType.fromJson(Map<String, dynamic> json) {
    return WpPostType(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class About {
  String? href;

  About({this.href});

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
