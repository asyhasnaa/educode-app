class GradeItem {
  final String? itemName;
  final String? gradeFormatted;
  final String? feedback;
  final int? gradedategraded; // Menambahkan parameter gradedategraded

  GradeItem({
    required this.itemName,
    required this.gradeFormatted,
    required this.feedback,
    required this.gradedategraded, // Tambahkan di konstruktor
  });

  // Factory method untuk parsing JSON
  factory GradeItem.fromJson(Map<String, dynamic> json) {
    return GradeItem(
      itemName: json['itemname'] as String?,
      gradeFormatted: json['gradeformatted'] as String?,
      feedback: json['feedback'] as String?,
      gradedategraded:
          json['gradedategraded'] as int?, // Parsing gradedategraded
    );
  }
}

class UserGrades {
  final List<GradeItem> gradeItems;

  UserGrades({
    required this.gradeItems,
  });

  factory UserGrades.fromJson(Map<String, dynamic> json) {
    var gradeItemsJson = json['gradeitems'] as List;
    List<GradeItem> gradeItemsList =
        gradeItemsJson.map((item) => GradeItem.fromJson(item)).toList();

    return UserGrades(
      gradeItems: gradeItemsList,
    );
  }
}
