import 'dart:convert';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:http/http.dart' as http;
import 'package:educode/models/api_response/detail_course_response.dart';

class ApiDetailCourseService {
  Future<List<DetailCourseResponse>?> getCourseDetail(int courseId) async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    if (token == null) return null;

    final response = await http.get(Uri.parse(
        '${ApiRoutes.baseFunctionUrl}wstoken=${ApiRoutes.wstoken}&moodlewsrestformat=json&wsfunction=${ApiRoutes.getDetailCourse}&courseid=$courseId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => DetailCourseResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load course details');
    }
  }
}
