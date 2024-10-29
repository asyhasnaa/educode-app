import 'dart:convert';

class SiteInfoResponse {
  String sitename;
  String username;
  String firstname;
  String lastname;
  String fullname;
  String lang;
  int userid;
  String siteurl;
  String userpictureurl;
  int downloadfiles;
  int uploadfiles;
  String release;
  String version;
  String mobilecssurl;
  List<Advancedfeature> advancedfeatures;
  bool usercanmanageownfiles;
  int userquota;
  int usermaxuploadfilesize;
  int userhomepage;
  String userprivateaccesskey;
  int siteid;
  String sitecalendartype;
  String usercalendartype;
  bool userissiteadmin;
  String theme;
  int limitconcurrentlogins;

  SiteInfoResponse({
    required this.sitename,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.lang,
    required this.userid,
    required this.siteurl,
    required this.userpictureurl,
    required this.downloadfiles,
    required this.uploadfiles,
    required this.release,
    required this.version,
    required this.mobilecssurl,
    required this.advancedfeatures,
    required this.usercanmanageownfiles,
    required this.userquota,
    required this.usermaxuploadfilesize,
    required this.userhomepage,
    required this.userprivateaccesskey,
    required this.siteid,
    required this.sitecalendartype,
    required this.usercalendartype,
    required this.userissiteadmin,
    required this.theme,
    required this.limitconcurrentlogins,
  });

  SiteInfoResponse copyWith({
    String? sitename,
    String? username,
    String? firstname,
    String? lastname,
    String? fullname,
    String? lang,
    int? userid,
    String? siteurl,
    String? userpictureurl,
    List<Function>? functions,
    int? downloadfiles,
    int? uploadfiles,
    String? release,
    String? version,
    String? mobilecssurl,
    List<Advancedfeature>? advancedfeatures,
    bool? usercanmanageownfiles,
    int? userquota,
    int? usermaxuploadfilesize,
    int? userhomepage,
    String? userprivateaccesskey,
    int? siteid,
    String? sitecalendartype,
    String? usercalendartype,
    bool? userissiteadmin,
    String? theme,
    int? limitconcurrentlogins,
  }) =>
      SiteInfoResponse(
        sitename: sitename ?? this.sitename,
        username: username ?? this.username,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        fullname: fullname ?? this.fullname,
        lang: lang ?? this.lang,
        userid: userid ?? this.userid,
        siteurl: siteurl ?? this.siteurl,
        userpictureurl: userpictureurl ?? this.userpictureurl,
        downloadfiles: downloadfiles ?? this.downloadfiles,
        uploadfiles: uploadfiles ?? this.uploadfiles,
        release: release ?? this.release,
        version: version ?? this.version,
        mobilecssurl: mobilecssurl ?? this.mobilecssurl,
        advancedfeatures: advancedfeatures ?? this.advancedfeatures,
        usercanmanageownfiles:
            usercanmanageownfiles ?? this.usercanmanageownfiles,
        userquota: userquota ?? this.userquota,
        usermaxuploadfilesize:
            usermaxuploadfilesize ?? this.usermaxuploadfilesize,
        userhomepage: userhomepage ?? this.userhomepage,
        userprivateaccesskey: userprivateaccesskey ?? this.userprivateaccesskey,
        siteid: siteid ?? this.siteid,
        sitecalendartype: sitecalendartype ?? this.sitecalendartype,
        usercalendartype: usercalendartype ?? this.usercalendartype,
        userissiteadmin: userissiteadmin ?? this.userissiteadmin,
        theme: theme ?? this.theme,
        limitconcurrentlogins:
            limitconcurrentlogins ?? this.limitconcurrentlogins,
      );

  factory SiteInfoResponse.fromRawJson(String str) =>
      SiteInfoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SiteInfoResponse.fromJson(Map<String, dynamic> json) =>
      SiteInfoResponse(
        sitename: json["sitename"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        fullname: json["fullname"],
        lang: json["lang"],
        userid: json["userid"],
        siteurl: json["siteurl"],
        userpictureurl: json["userpictureurl"],
        downloadfiles: json["downloadfiles"],
        uploadfiles: json["uploadfiles"],
        release: json["release"],
        version: json["version"],
        mobilecssurl: json["mobilecssurl"],
        advancedfeatures: List<Advancedfeature>.from(
            json["advancedfeatures"].map((x) => Advancedfeature.fromJson(x))),
        usercanmanageownfiles: json["usercanmanageownfiles"],
        userquota: json["userquota"],
        usermaxuploadfilesize: json["usermaxuploadfilesize"],
        userhomepage: json["userhomepage"],
        userprivateaccesskey: json["userprivateaccesskey"],
        siteid: json["siteid"],
        sitecalendartype: json["sitecalendartype"],
        usercalendartype: json["usercalendartype"],
        userissiteadmin: json["userissiteadmin"],
        theme: json["theme"],
        limitconcurrentlogins: json["limitconcurrentlogins"],
      );

  Map<String, dynamic> toJson() => {
        "sitename": sitename,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "fullname": fullname,
        "lang": lang,
        "userid": userid,
        "siteurl": siteurl,
        "userpictureurl": userpictureurl,
        "downloadfiles": downloadfiles,
        "uploadfiles": uploadfiles,
        "release": release,
        "version": version,
        "mobilecssurl": mobilecssurl,
        "advancedfeatures":
            List<dynamic>.from(advancedfeatures.map((x) => x.toJson())),
        "usercanmanageownfiles": usercanmanageownfiles,
        "userquota": userquota,
        "usermaxuploadfilesize": usermaxuploadfilesize,
        "userhomepage": userhomepage,
        "userprivateaccesskey": userprivateaccesskey,
        "siteid": siteid,
        "sitecalendartype": sitecalendartype,
        "usercalendartype": usercalendartype,
        "userissiteadmin": userissiteadmin,
        "theme": theme,
        "limitconcurrentlogins": limitconcurrentlogins,
      };
}

class Advancedfeature {
  String name;
  int value;

  Advancedfeature({
    required this.name,
    required this.value,
  });

  Advancedfeature copyWith({
    String? name,
    int? value,
  }) =>
      Advancedfeature(
        name: name ?? this.name,
        value: value ?? this.value,
      );

  factory Advancedfeature.fromRawJson(String str) =>
      Advancedfeature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advancedfeature.fromJson(Map<String, dynamic> json) =>
      Advancedfeature(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
