class ProfileUpdateResponse {
  String? first_name;
  String? last_name;
  String? message;
  String? profile_image;
  List<int>? my_topics;

  ProfileUpdateResponse({this.first_name, this.last_name, this.message, this.profile_image, this.my_topics});

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      first_name: json['first_name'],
      profile_image: json['news_profile_image'],
      last_name: json['last_name'],
      message: json['message'],
      my_topics: json['my_topics'] != null ? new List<int>.from(json['my_topics']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['news_profile_image'] = this.profile_image;
    data['message'] = this.message;
    if (this.my_topics != null) {
      data['my_topics'] = this.my_topics;
    }
    return data;
  }
}
