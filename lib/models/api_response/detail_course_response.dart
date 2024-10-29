class DetailCourseResponse {
  final int id;
  final String name;
  final String summary;
  final List<Module> modules;

  DetailCourseResponse({
    required this.id,
    required this.name,
    required this.summary,
    required this.modules,
  });

  // Factory method to create an instance of DetailCourseResponse from JSON
  factory DetailCourseResponse.fromJson(Map<String, dynamic> json) {
    return DetailCourseResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      summary: json['summary'] ?? '',
      modules: json['modules'] != null
          ? List<Module>.from(
              json['modules'].map((module) => Module.fromJson(module)))
          : [],
    );
  }

  // Method to convert DetailCourseResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}

class Module {
  final int id;
  final String name;
  final String modname;
  final List<Date> dates;

  Module({
    required this.id,
    required this.name,
    required this.modname,
    required this.dates,
  });

  // Factory method to create an instance of Module from JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      modname: json['modname'] ?? '',
      dates: json['dates'] != null
          ? List<Date>.from(json['dates'].map((date) => Date.fromJson(date)))
          : [],
    );
  }

  // Method to convert Module to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'modname': modname,
      'dates': dates.map((date) => date.toJson()).toList(),
    };
  }
}

class Date {
  final String label;
  final int timestamp;

  Date({
    required this.label,
    required this.timestamp,
  });

  // Factory method to create an instance of Date from JSON
  factory Date.fromJson(Map<String, dynamic> json) {
    // Fallback to empty string for label and 0 for timestamp if they are null
    return Date(
      label: json['label'] ?? 'Unknown Label', // Provide a default value
      timestamp: json['timestamp'] ?? 0, // Provide a default timestamp value
    );
  }

  // Method to convert Date to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'timestamp': timestamp,
    };
  }
}
