import 'dart:convert';
import 'package:educode/models/api_response/course_response.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:http/http.dart' as http;

class ApiCourseService {
  Future<List<CourseUserResponse>?> getCourse() async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    final userId = await loginService.getUserIdFromPrefs();
    if (token == null) return null;
    if (userId == null) return null;

    final response = await http.get(Uri.parse(
      '${ApiRoutes.baseFunctionUrl}wstoken=$token&moodlewsrestformat=json&wsfunction=${ApiRoutes.getUserCourse}&userid=$userId',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map((course) => CourseUserResponse.fromJson(course))
            .toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
