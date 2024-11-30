import 'dart:convert';

import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:http/http.dart' as http;

class ApiGradeReportService {
  Future<UserGrades> getUserGradesForCourse(int courseId, int userId) async {
    final response = await http.get(
      Uri.parse(
          'https://lms.educode.id/webservice/rest/server.php?wstoken=eb60c3bda800422e20df49087f462e81&moodlewsrestformat=json&wsfunction=gradereport_user_get_grade_items&courseid=$courseId&userid=$userId'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      var userGradesJson = json['usergrades'][0];
      return UserGrades.fromJson(userGradesJson);
    } else {
      throw Exception('Failed to load grades for course $courseId');
    }
  }
}
