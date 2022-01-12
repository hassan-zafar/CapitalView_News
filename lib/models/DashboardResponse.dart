class DashboardResponse {
  String? app_lang;
  List<Banner>? banner;
  int? feature_num_pages;
  List<NewsData>? breaking_post;
  int? recent_num_pages;
  List<NewsData>? recent_post;
  List<NewsData>? story_post;
  List<VideoData>? videos;
  SocialLink? social_link;

  DashboardResponse({
    this.app_lang,
    this.banner,
    this.story_post,
    this.feature_num_pages,
    this.videos,
    this.breaking_post,
    this.recent_num_pages,
    this.recent_post,
    this.social_link,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      app_lang: json['app_lang'],
      banner: json['banner'] != null ? (json['banner'] as List).map((i) => Banner.fromJson(i)).toList() : null,
      feature_num_pages: json['feature_num_pages'],
      breaking_post: json['feature_post'] != null ? (json['feature_post'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      recent_num_pages: json['recent_num_pages'],
      recent_post: json['recent_post'] != null ? (json['recent_post'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      story_post: json['story_post'] != null ? (json['story_post'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      videos: json['videos'] != null ? (json['videos'] as List).map((i) => VideoData.fromJson(i)).toList() : null,
      social_link: json['social_link'] != null ? SocialLink.fromJson(json['social_link']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_lang'] = this.app_lang;
    data['feature_num_pages'] = this.feature_num_pages;
    data['recent_num_pages'] = this.recent_num_pages;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.breaking_post != null) {
      data['feature_post'] = this.breaking_post!.map((v) => v.toJson()).toList();
    }
    if (this.recent_post != null) {
      data['recent_post'] = this.recent_post!.map((v) => v.toJson()).toList();
    }
    if (this.story_post != null) {
      data['story_post'] = this.story_post!.map((v) => v.toJson()).toList();
    }
    if (this.social_link != null) {
      data['social_link'] = this.social_link!.toJson();
    }
    return data;
  }
}

class Banner {
  String? desc;
  String? image;
  String? thumb;
  String? url;

  Banner({this.desc, this.image, this.thumb, this.url});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      desc: json['desc'],
      image: json['image'],
      thumb: json['thumb'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['url'] = this.url;
    return data;
  }
}

class VideoData {
  String? created_at;
  int? id;
  String? image_url;
  String? title;
  String? video_type;
  String? video_url;

  VideoData({this.created_at, this.id, this.image_url, this.title, this.video_type, this.video_url});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      created_at: json['created_at'],
      id: json['id'],
      image_url: json['image_url'],
      title: json['title'],
      video_type: json['video_type'],
      video_url: json['video_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['image_url'] = this.image_url;
    data['title'] = this.title;
    data['video_type'] = this.video_type;
    data['video_url'] = this.video_url;
    return data;
  }
}

class NewsData {
  String? human_time_diff;
  int? iD;
  String? image;
  String? full_image;
  bool? is_fav;
  String? no_of_comments_text;
  String? post_content;
  String? post_date;
  String? post_date_gmt;
  String? post_excerpt;
  String? post_title;
  String? readable_date;
  String? share_url;
  String? post_author_name;
  String? post_author_image;
  int? post_view;

  List<Category>? category;
  String? comment_count;
  String? comment_status;
  String? filter;
  int? menu_order;
  String? ping_status;
  String? pinged;
  String? post_author;
  String? post_content_filtered;
  String? post_mime_type;
  String? post_modified;
  String? post_modified_gmt;
  String? post_name;
  int? post_parent;
  String? post_password;
  String? post_status;
  String? post_type;
  List<NewsData>? related_news;
  String? to_ping;

  NewsData({
    this.post_author_name,
    this.post_author_image,
    this.human_time_diff,
    this.iD,
    this.image,
    this.is_fav,
    this.no_of_comments_text,
    this.post_content,
    this.post_date,
    this.post_date_gmt,
    this.post_excerpt,
    this.post_title,
    this.readable_date,
    this.share_url,
    this.post_view,
    this.category,
    this.comment_count,
    this.comment_status,
    this.filter,
    this.menu_order,
    this.ping_status,
    this.pinged,
    this.post_author,
    this.post_content_filtered,
    this.post_mime_type,
    this.post_modified,
    this.post_modified_gmt,
    this.post_name,
    this.post_parent,
    this.post_password,
    this.post_status,
    this.post_type,
    this.related_news,
    this.to_ping,
    this.full_image,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      human_time_diff: json['human_time_diff'],
      iD: json['ID'],
      image: json['image'],
      is_fav: json['is_fav'],
      no_of_comments_text: json['no_of_comments_text'],
      post_content: json['post_content'],
      post_date: json['post_date'],
      post_date_gmt: json['post_date_gmt'],
      post_excerpt: json['post_excerpt'],
      post_title: json['post_title'],
      readable_date: json['readable_date'],
      share_url: json['share_url'],
      post_author_name: json['post_author_name'],
      post_author_image: json['post_author_image'],
      post_view: json['post_view'],
      category: json['category'] != null ? (json['category'] as List).map((i) => Category.fromJson(i)).toList() : null,
      comment_count: json['comment_count'],
      comment_status: json['comment_status'],
      filter: json['filter'],
      menu_order: json['menu_order'],
      ping_status: json['ping_status'],
      pinged: json['pinged'],
      post_author: json['post_author'],
      post_content_filtered: json['post_content_filtered'],
      post_mime_type: json['post_mime_type'],
      post_modified: json['post_modified'],
      post_modified_gmt: json['post_modified_gmt'],
      post_name: json['post_name'],
      post_parent: json['post_parent'],
      post_password: json['post_password'],
      post_status: json['post_status'],
      post_type: json['post_type'],
      related_news: json['related_news'] != null ? (json['related_news'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      to_ping: json['to_ping'],
      full_image: json['full_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['human_time_diff'] = this.human_time_diff;
    data['ID'] = this.iD;
    data['image'] = this.image;
    data['is_fav'] = this.is_fav;
    data['no_of_comments_text'] = this.no_of_comments_text;
    data['post_content'] = this.post_content;
    data['post_date'] = this.post_date;
    data['post_date_gmt'] = this.post_date_gmt;
    data['post_excerpt'] = this.post_excerpt;
    data['post_title'] = this.post_title;
    data['readable_date'] = this.readable_date;
    data['share_url'] = this.share_url;
    data['post_author_name'] = this.post_author_name;
    data['post_author_image'] = this.post_author_image;
    data['post_view'] = this.post_view;

    data['comment_count'] = this.comment_count;
    data['comment_status'] = this.comment_status;
    data['filter'] = this.filter;
    data['menu_order'] = this.menu_order;
    data['ping_status'] = this.ping_status;
    data['pinged'] = this.pinged;
    data['post_author'] = this.post_author;
    data['post_content_filtered'] = this.post_content_filtered;
    data['post_mime_type'] = this.post_mime_type;
    data['post_modified'] = this.post_modified;
    data['post_modified_gmt'] = this.post_modified_gmt;
    data['post_name'] = this.post_name;
    data['post_parent'] = this.post_parent;
    data['post_password'] = this.post_password;
    data['post_status'] = this.post_status;
    data['post_type'] = this.post_type;
    data['to_ping'] = this.to_ping;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.related_news != null) {
      data['related_news'] = this.related_news!.map((v) => v.toJson()).toList();
    }
    data['full_image'] = this.full_image;
    return data;
  }
}

class SocialLink {
  String? contact;
  String? copyrightText;
  String? facebook;
  String? instagram;
  String? privacyPolicy;
  String? termCondition;
  String? twitter;
  String? whatsApp;
  bool? disableAd;
  bool? disableLocation;
  bool? disableTwitter;
  bool? disableHeadline;
  bool? disableQuickRead;
  bool? disableStory;
  String? copyright_text;

  SocialLink({
    this.contact,
    this.disableLocation,
    this.disableTwitter,
    this.disableAd,
    this.copyrightText,
    this.facebook,
    this.instagram,
    this.privacyPolicy,
    this.termCondition,
    this.twitter,
    this.whatsApp,
    this.disableHeadline,
    this.disableQuickRead,
    this.disableStory,
    this.copyright_text,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      contact: json['contact'],
      copyrightText: json['copyright_text'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      privacyPolicy: json['privacy_policy'],
      termCondition: json['term_condition'],
      twitter: json['twitter'],
      whatsApp: json['whatsapp'],
      disableAd: json['disable_ad'],
      disableLocation: json['disable_location'],
      disableTwitter: json['disable_twitter'],
      disableHeadline: json['disable_headline'],
      disableQuickRead: json['disable_quickread'],
      disableStory: json['disable_story'],
      copyright_text: json['copyright_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['copyright_text'] = this.copyrightText;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['privacy_policy'] = this.privacyPolicy;
    data['term_condition'] = this.termCondition;
    data['twitter'] = this.twitter;
    data['whatsapp'] = this.whatsApp;
    data['disable_location'] = this.disableLocation;
    data['disable_ad'] = this.disableAd;
    data['disable_twitter'] = this.disableTwitter;
    data['disable_headline'] = this.disableHeadline;
    data['disable_quickread'] = this.disableQuickRead;
    data['disable_story'] = this.disableStory;
    data['copyright_text'] = this.copyright_text;
    return data;
  }
}

class Category {
  int? cat_ID;
  String? cat_name;
  int? category_count;
  String? category_description;
  String? category_nicename;
  int? category_parent;
  int? count;
  String? description;
  String? filter;
  String? name;
  int? parent;
  String? slug;
  String? taxonomy;
  int? term_group;
  int? term_id;
  int? term_taxonomy_id;

  String? image;

  Category({
    this.cat_ID,
    this.cat_name,
    this.category_count,
    this.category_description,
    this.category_nicename,
    this.category_parent,
    this.count,
    this.description,
    this.filter,
    this.name,
    this.parent,
    this.slug,
    this.taxonomy,
    this.term_group,
    this.term_id,
    this.term_taxonomy_id,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      cat_ID: json['cat_ID'],
      cat_name: json['cat_name'],
      category_count: json['category_count'],
      category_description: json['category_description'],
      category_nicename: json['category_nicename'],
      category_parent: json['category_parent'],
      count: json['count'],
      description: json['description'],
      filter: json['filter'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
      taxonomy: json['taxonomy'],
      term_group: json['term_group'],
      term_id: json['term_id'],
      term_taxonomy_id: json['term_taxonomy_id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_ID'] = this.cat_ID;
    data['cat_name'] = this.cat_name;
    data['category_count'] = this.category_count;
    data['category_description'] = this.category_description;
    data['category_nicename'] = this.category_nicename;
    data['category_parent'] = this.category_parent;
    data['count'] = this.count;
    data['description'] = this.description;
    data['filter'] = this.filter;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    data['taxonomy'] = this.taxonomy;
    data['term_group'] = this.term_group;
    data['term_id'] = this.term_id;
    data['term_taxonomy_id'] = this.term_taxonomy_id;
    data['image'] = this.image;
    return data;
  }
}
