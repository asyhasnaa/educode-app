import 'dart:convert';

import 'package:educode/models/api_response/profile_model.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:http/http.dart' as http;

class ApiProfileService {
  Future<ProfileUserResponse?> getProfile() async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    if (token == null) return null;
    final userId = await loginService.getUserIdFromPrefs();
    if (userId == null) return null;

    final response = await http.get(
      Uri.parse(
          '${ApiRoutes.baseFunctionUrl}wstoken=$token&moodlewsrestformat=json&wsfunction=${ApiRoutes.profileUser}&field=id&values[0]=$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty && data is List) {
        return ProfileUserResponse.fromJson(data[0]);
      } else {
        throw Exception('User Profile Not Found');
      }
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
