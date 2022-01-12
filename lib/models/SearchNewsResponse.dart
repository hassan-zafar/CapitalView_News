import 'package:mighty_news/models/DashboardResponse.dart';

class SearchNewsResponse {
  int? num_pages;
  List<NewsData>? posts;

  SearchNewsResponse({this.num_pages, this.posts});

  factory SearchNewsResponse.fromJson(Map<String, dynamic> json) {
    return SearchNewsResponse(
      num_pages: json['num_pages'],
      posts: json['posts'] != null ? (json['posts'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_pages'] = this.num_pages;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
