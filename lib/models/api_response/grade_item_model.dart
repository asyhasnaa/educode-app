class GradeReportResponse {
  final String? itemName;
  final String? gradeFormatted;
  final String? feedback;
  final int? gradedategraded; // Menambahkan parameter gradedategraded

  GradeReportResponse({
    required this.itemName,
    required this.gradeFormatted,
    required this.feedback,
    required this.gradedategraded, // Tambahkan di konstruktor
  });

  // Factory method untuk parsing JSON
  factory GradeReportResponse.fromJson(Map<String, dynamic> json) {
    return GradeReportResponse(
      itemName: json['itemname'] as String?,
      gradeFormatted: json['gradeformatted'] as String?,
      feedback: json['feedback'] as String?,
      gradedategraded:
          json['gradedategraded'] as int?, // Parsing gradedategraded
    );
  }
}

class UserGrades {
  final List<GradeReportResponse> gradeItems;

  UserGrades({
    required this.gradeItems,
  });

  factory UserGrades.fromJson(Map<String, dynamic> json) {
    var gradeItemsJson = json['gradeitems'] as List;
    List<GradeReportResponse> gradeItemsList = gradeItemsJson
        .map((item) => GradeReportResponse.fromJson(item))
        .toList();

    return UserGrades(
      gradeItems: gradeItemsList,
    );
  }
}
