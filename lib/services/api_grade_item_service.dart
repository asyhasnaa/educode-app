import 'dart:convert';

import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:http/http.dart' as http;

class ApiGradeItemService {
  Future<UserGrades?> getUserGrades(int courseId) async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    final userid = await loginService.getUserIdFromPrefs();
    if (token == null || userid == null) {
      throw Exception('Token or User ID is null');
    }

    final response = await http.get(
      Uri.parse(
          'https://lms.educode.id/webservice/rest/server.php?wstoken=$token&moodlewsrestformat=json&wsfunction=gradereport_user_get_grade_items&courseid=$courseId&userid=$userid'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      var userGradesJson =
          json['usergrades'][0]; // Mengakses objek 'usergrades'
      return UserGrades.fromJson(userGradesJson); // Parsing menggunakan model
    } else {
      throw Exception('Failed to load grades');
    }
  }
}
