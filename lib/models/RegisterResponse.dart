class RegisterResponse {
  Data? data;
  String? message;

  RegisterResponse({this.data, this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? first_name;
  String? last_name;
  String? user_email;
  String? user_login;

  Data({this.first_name, this.last_name, this.user_email, this.user_login});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      first_name: json['first_name'],
      last_name: json['last_name'],
      user_email: json['user_email'],
      user_login: json['user_login'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['user_email'] = this.user_email;
    data['user_login'] = this.user_login;
    return data;
  }
}
