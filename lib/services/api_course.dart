import 'dart:convert';
import 'package:educode/models/api_response/course_response.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiCourseService {
  //Metode untuk mendapatkan semua data nama course di Moodle
  Future<List<String>> getAllCourses() async {
    final url = Uri.parse(
        '${ApiRoutes.baseFunctionUrl}wstoken=${ApiRoutes.wstoken}&moodlewsrestformat=json&wsfunction=core_course_get_courses');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((course) => course['fullname'].toString()).toList();
      } else {
        throw Exception('Tidak ada kursus ditemukan.');
      }
    } else {
      throw Exception('Gagal memuat kursus: ${response.statusCode}');
    }
  }

  //Metode untuk mendapatkan data course sesuai ID Anak
  Future<List<CourseUserResponse>?> getCourse(int selectedUserId) async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    if (kDebugMode) {
      print("ChildId selected = $selectedUserId");
    }
    if (token == null) {
      if (kDebugMode) {
        print("ChildId is null");
      }
      return null;
    }
    final response = await http.get(Uri.parse(
      '${ApiRoutes.baseFunctionUrl}wstoken=${ApiRoutes.wstoken}&moodlewsrestformat=json&wsfunction=${ApiRoutes.getUserCourse}&userid=$selectedUserId',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print("Debug: Response Course from API: $data");
      }
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
