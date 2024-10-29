import 'dart:convert';

class CourseUserResponse {
  int id;
  String shortname;
  String fullname;
  String displayname;
  int enrolledusercount;
  String idnumber;
  int visible;
  String summary;
  int summaryformat;
  String format;
  String courseimage;
  bool showgrades;
  String lang;
  bool enablecompletion;
  bool completionhascriteria;
  bool completionusertracked;
  int category;
  double progress;
  bool completed;
  int startdate;
  int enddate;
  int marker;
  int lastaccess;
  bool isfavourite;
  bool hidden;
  List<dynamic> overviewfiles;
  bool showactivitydates;
  bool showcompletionconditions;
  int timemodified;

  CourseUserResponse({
    required this.id,
    required this.shortname,
    required this.fullname,
    required this.displayname,
    required this.enrolledusercount,
    required this.idnumber,
    required this.visible,
    required this.summary,
    required this.summaryformat,
    required this.format,
    required this.courseimage,
    required this.showgrades,
    required this.lang,
    required this.enablecompletion,
    required this.completionhascriteria,
    required this.completionusertracked,
    required this.category,
    required this.progress,
    required this.completed,
    required this.startdate,
    required this.enddate,
    required this.marker,
    required this.lastaccess,
    required this.isfavourite,
    required this.hidden,
    required this.overviewfiles,
    required this.showactivitydates,
    required this.showcompletionconditions,
    required this.timemodified,
  });

  CourseUserResponse copyWith({
    int? id,
    String? shortname,
    String? fullname,
    String? displayname,
    int? enrolledusercount,
    String? idnumber,
    int? visible,
    String? summary,
    int? summaryformat,
    String? format,
    String? courseimage,
    bool? showgrades,
    String? lang,
    bool? enablecompletion,
    bool? completionhascriteria,
    bool? completionusertracked,
    int? category,
    double? progress,
    bool? completed,
    int? startdate,
    int? enddate,
    int? marker,
    int? lastaccess,
    bool? isfavourite,
    bool? hidden,
    List<dynamic>? overviewfiles,
    bool? showactivitydates,
    bool? showcompletionconditions,
    int? timemodified,
  }) =>
      CourseUserResponse(
        id: id ?? this.id,
        shortname: shortname ?? this.shortname,
        fullname: fullname ?? this.fullname,
        displayname: displayname ?? this.displayname,
        enrolledusercount: enrolledusercount ?? this.enrolledusercount,
        idnumber: idnumber ?? this.idnumber,
        visible: visible ?? this.visible,
        summary: summary ?? this.summary,
        summaryformat: summaryformat ?? this.summaryformat,
        format: format ?? this.format,
        courseimage: courseimage ?? this.courseimage,
        showgrades: showgrades ?? this.showgrades,
        lang: lang ?? this.lang,
        enablecompletion: enablecompletion ?? this.enablecompletion,
        completionhascriteria:
            completionhascriteria ?? this.completionhascriteria,
        completionusertracked:
            completionusertracked ?? this.completionusertracked,
        category: category ?? this.category,
        progress: progress ?? this.progress,
        completed: completed ?? this.completed,
        startdate: startdate ?? this.startdate,
        enddate: enddate ?? this.enddate,
        marker: marker ?? this.marker,
        lastaccess: lastaccess ?? this.lastaccess,
        isfavourite: isfavourite ?? this.isfavourite,
        hidden: hidden ?? this.hidden,
        overviewfiles: overviewfiles ?? this.overviewfiles,
        showactivitydates: showactivitydates ?? this.showactivitydates,
        showcompletionconditions:
            showcompletionconditions ?? this.showcompletionconditions,
        timemodified: timemodified ?? this.timemodified,
      );

  factory CourseUserResponse.fromRawJson(String str) =>
      CourseUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseUserResponse.fromJson(Map<String, dynamic> json) =>
      CourseUserResponse(
        id: json["id"],
        shortname: json["shortname"],
        fullname: json["fullname"],
        displayname: json["displayname"],
        enrolledusercount: json["enrolledusercount"],
        idnumber: json["idnumber"] ?? '',
        visible: json["visible"],
        summary: json["summary"] ?? '',
        summaryformat: json["summaryformat"],
        format: json["format"],
        courseimage: json["courseimage"],
        showgrades: json["showgrades"],
        lang: json["lang"] ?? '',
        enablecompletion: json["enablecompletion"],
        completionhascriteria: json["completionhascriteria"],
        completionusertracked: json["completionusertracked"],
        category: json["category"],
        progress: (json["progress"] ?? 0.0).toDouble(),
        completed: json["completed"],
        startdate: json["startdate"],
        enddate: json["enddate"],
        marker: json["marker"],
        lastaccess: json["lastaccess"],
        isfavourite: json["isfavourite"],
        hidden: json["hidden"],
        overviewfiles: List<dynamic>.from(json["overviewfiles"].map((x) => x)),
        showactivitydates: json["showactivitydates"],
        showcompletionconditions: json["showcompletionconditions"],
        timemodified: json["timemodified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shortname": shortname,
        "fullname": fullname,
        "displayname": displayname,
        "enrolledusercount": enrolledusercount,
        "idnumber": idnumber,
        "visible": visible,
        "summary": summary,
        "summaryformat": summaryformat,
        "format": format,
        "courseimage": courseimage,
        "showgrades": showgrades,
        "lang": lang,
        "enablecompletion": enablecompletion,
        "completionhascriteria": completionhascriteria,
        "completionusertracked": completionusertracked,
        "category": category,
        "progress": progress,
        "completed": completed,
        "startdate": startdate,
        "enddate": enddate,
        "marker": marker,
        "lastaccess": lastaccess,
        "isfavourite": isfavourite,
        "hidden": hidden,
        "overviewfiles": List<dynamic>.from(overviewfiles.map((x) => x)),
        "showactivitydates": showactivitydates,
        "showcompletionconditions": showcompletionconditions,
        "timemodified": timemodified,
      };
}
