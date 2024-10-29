import 'dart:convert';

class ProfileUserResponse {
  int? id;
  String? username;
  String? firstname;
  String? lastname;
  String? fullname;
  String? email;
  String? department;
  int? firstaccess;
  int? lastaccess;
  String? auth;
  bool? suspended;
  bool? confirmed;
  String? lang;
  String? theme;
  String? timezone;
  int? mailformat;
  String? description;
  int? descriptionformat;
  String? profileimageurlsmall;
  String? profileimageurl;

  ProfileUserResponse({
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.fullname,
    this.email,
    this.department,
    this.firstaccess,
    this.lastaccess,
    this.auth,
    this.suspended,
    this.confirmed,
    this.lang,
    this.theme,
    this.timezone,
    this.mailformat,
    this.description,
    this.descriptionformat,
    this.profileimageurlsmall,
    this.profileimageurl,
  });

  ProfileUserResponse copyWith({
    int? id,
    String? username,
    String? firstname,
    String? lastname,
    String? fullname,
    String? email,
    String? department,
    int? firstaccess,
    int? lastaccess,
    String? auth,
    bool? suspended,
    bool? confirmed,
    String? lang,
    String? theme,
    String? timezone,
    int? mailformat,
    String? description,
    int? descriptionformat,
    String? profileimageurlsmall,
    String? profileimageurl,
  }) =>
      ProfileUserResponse(
        id: id ?? this.id,
        username: username ?? this.username,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        fullname: fullname ?? this.fullname,
        email: email ?? this.email,
        department: department ?? this.department,
        firstaccess: firstaccess ?? this.firstaccess,
        lastaccess: lastaccess ?? this.lastaccess,
        auth: auth ?? this.auth,
        suspended: suspended ?? this.suspended,
        confirmed: confirmed ?? this.confirmed,
        lang: lang ?? this.lang,
        theme: theme ?? this.theme,
        timezone: timezone ?? this.timezone,
        mailformat: mailformat ?? this.mailformat,
        description: description ?? this.description,
        descriptionformat: descriptionformat ?? this.descriptionformat,
        profileimageurlsmall: profileimageurlsmall ?? this.profileimageurlsmall,
        profileimageurl: profileimageurl ?? this.profileimageurl,
      );

  factory ProfileUserResponse.fromRawJson(String str) =>
      ProfileUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileUserResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUserResponse(
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        fullname: json["fullname"],
        email: json["email"],
        department: json["department"],
        firstaccess: json["firstaccess"],
        lastaccess: json["lastaccess"],
        auth: json["auth"],
        suspended: json["suspended"],
        confirmed: json["confirmed"],
        lang: json["lang"],
        theme: json["theme"],
        timezone: json["timezone"],
        mailformat: json["mailformat"],
        description: json["description"],
        descriptionformat: json["descriptionformat"],
        profileimageurlsmall: json["profileimageurlsmall"],
        profileimageurl: json["profileimageurl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "fullname": fullname,
        "email": email,
        "department": department,
        "firstaccess": firstaccess,
        "lastaccess": lastaccess,
        "auth": auth,
        "suspended": suspended,
        "confirmed": confirmed,
        "lang": lang,
        "theme": theme,
        "timezone": timezone,
        "mailformat": mailformat,
        "description": description,
        "descriptionformat": descriptionformat,
        "profileimageurlsmall": profileimageurlsmall,
        "profileimageurl": profileimageurl,
      };
}
