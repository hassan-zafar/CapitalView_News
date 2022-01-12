class LoginResponse {
  String? first_name;
  String? last_name;
  List<int>? my_topics;
  String? profile_image;
  String? token;
  String? user_display_name;
  String? user_email;
  int? user_id;
  String? user_nicename;
  MyPreferenceData? myPreference;

  LoginResponse({this.first_name, this.last_name, this.my_topics, this.profile_image, this.token, this.user_display_name, this.user_email, this.user_id, this.user_nicename, this.myPreference});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      first_name: json['first_name'],
      last_name: json['last_name'],
      my_topics: json['my_topics'] != null ? List<int>.from(json['my_topics']) : null,
      profile_image: json['news_profile_image'],
      token: json['token'],
      user_display_name: json['user_display_name'],
      user_email: json['user_email'],
      user_id: json['user_id'],
      user_nicename: json['user_nicename'],
      myPreference: json['my_preference'] != null ? MyPreferenceData.fromJson(json['my_preference']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['news_profile_image'] = this.profile_image;
    data['token'] = this.token;
    data['user_display_name'] = this.user_display_name;
    data['user_email'] = this.user_email;
    data['user_id'] = this.user_id;
    data['user_nicename'] = this.user_nicename;
    if (this.my_topics != null) {
      data['my_topics'] = this.my_topics;
    }
    if (this.myPreference != null) {
      data['my_preference'] = this.myPreference!.toJson();
    }
    return data;
  }
}

class MyPreferenceData {
  int? themeMode;
  int? detailVariant;

  MyPreferenceData({this.themeMode, this.detailVariant});

  factory MyPreferenceData.fromJson(Map<String, dynamic> json) {
    return MyPreferenceData(
      themeMode: json['themeMode'],
      detailVariant: json['detailVariant'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['themeMode'] = this.themeMode;
    data['detailVariant'] = this.detailVariant;
    return data;
  }
}
