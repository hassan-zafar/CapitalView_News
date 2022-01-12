import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentData {
  int? author;
  String? author_name;
  String? author_url;
  Content? content;
  String? date;
  String? date_gmt;
  int? id;
  String? link;
  List<Object>? meta;
  int? parent;
  int? post;
  String? status;
  String? type;
  AuthorAvatarUrls? author_avatar_urls;

  bool get isMyComment  => author == getIntAsync(USER_ID);





  CommentData({this.author, this.author_name, this.author_url, this.content, this.date, this.date_gmt, this.id, this.link, this.meta, this.parent, this.post, this.status, this.type, this.author_avatar_urls});

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      author: json['author'],
      author_name: json['author_name'],
      author_url: json['author_url'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      date_gmt: json['date_gmt'],
      id: json['id'],
      link: json['link'],
      parent: json['parent'],
      post: json['post'],
      status: json['status'],
      type: json['type'],
      author_avatar_urls: json['author_avatar_urls'] != null ? AuthorAvatarUrls.fromJson(json['author_avatar_urls']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['author_name'] = this.author_name;
    data['author_url'] = this.author_url;
    data['date'] = this.date;
    data['date_gmt'] = this.date_gmt;
    data['id'] = this.id;
    data['link'] = this.link;
    data['parent'] = this.parent;
    data['post'] = this.post;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.author_avatar_urls != null) {
      data['author_avatar_urls'] = this.author_avatar_urls!.toJson();
    }
    return data;
  }
}

class Content {
  String? rendered;

  Content({this.rendered});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}

class Links {
  List<Author>? author;
  List<Collection>? collection;
  List<Self>? self;
  List<Up>? up;

  Links({this.author, this.collection, this.self, this.up});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      author: json['author'] != null ? (json['author'] as List).map((i) => Author.fromJson(i)).toList() : null,
      collection: json['collection'] != null ? (json['collection'] as List).map((i) => Collection.fromJson(i)).toList() : null,
      self: json['self'] != null ? (json['self'] as List).map((i) => Self.fromJson(i)).toList() : null,
      up: json['up'] != null ? (json['up'] as List).map((i) => Up.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.up != null) {
      data['up'] = this.up!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Up {
  bool? embeddable;
  String? href;
  String? post_type;

  Up({this.embeddable, this.href, this.post_type});

  factory Up.fromJson(Map<String, dynamic> json) {
    return Up(
      embeddable: json['embeddable'],
      href: json['href'],
      post_type: json['post_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    data['post_type'] = this.post_type;
    return data;
  }
}

class Author {
  bool? embeddable;
  String? href;

  Author({this.embeddable, this.href});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      embeddable: json['embeddable'],
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
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

class AuthorAvatarUrls {
  String? url;

  AuthorAvatarUrls({this.url});

  factory AuthorAvatarUrls.fromJson(Map<String, dynamic> json) {
    return AuthorAvatarUrls(
      url: json['96'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['96'] = this.url;
    return data;
  }
}
