import 'dart:convert';

class LoginResponse {
  String token;
  dynamic privatetoken;

  LoginResponse({
    required this.token,
    required this.privatetoken,
  });

  LoginResponse copyWith({
    String? token,
    dynamic privatetoken,
  }) =>
      LoginResponse(
        token: token ?? this.token,
        privatetoken: privatetoken ?? this.privatetoken,
      );

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        privatetoken: json["privatetoken"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "privatetoken": privatetoken,
      };
}
