import 'dart:convert';
import 'package:educode/models/api_response/login_response.dart';
import 'package:educode/models/api_response/site_info_response.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiAuthService {
  //PARENT LOGIN TO APP
  Future<LoginResponse?> loginApp(String username, String password) async {
    String? existingToken = await getToken();
    if (existingToken != null) {
      return LoginResponse(token: existingToken, privatetoken: null);
    }

    final response = await http.post(Uri.parse(ApiRoutes.loginApp), body: {
      'username': username,
      'password': password,
      'service': ApiRoutes.service,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login response data: $data");
      if (data.containsKey('token')) {
        // Save the token
        String token = data['token'];
        dynamic privatetoken = data['privatetoken'];
        await saveToken(token);

        // Fetch and save the user ID
        SiteInfoResponse? userInfo = await fetchUserId(token);
        if (userInfo != null) {
          await saveUserId(userInfo.userid);
        }

        return LoginResponse(token: token, privatetoken: privatetoken);
      } else {
        print("Token not found in response");
        return null;
      }
    } else {
      print("Login failed with status code: ${response.statusCode}");
      return null;
    }
  }

  // Mengambil UserID Pengguna menggunakan Token
  Future<SiteInfoResponse?> fetchUserId(String token) async {
    final token = await getToken();
    if (token == null) return null;

    final responseInfo = await http.post(
      Uri.parse(
          '${ApiRoutes.baseFunctionUrl}wstoken=$token&moodlewsrestformat=json&wsfunction=${ApiRoutes.userId}'),
    );

    if (responseInfo.statusCode == 200) {
      final data = jsonDecode(responseInfo.body);
      print("User info response data: $data");

      if (data.containsKey('userid')) {
        return SiteInfoResponse.fromJson(data);
      } else {
        // Handle the case where 'userid' is not present in the response
        throw Exception('userid not found in response');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  }

  // Menyimpan Token ke shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print("Token disimpan ke Shared Preferences: $token");
  }

// Mendapatkan token dari shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      print("Token diambil dari Shared Preferences: $token");
    } else {
      print("Tidak ada token di Shared Preferences.");
    }
    return token;
  }

  // Menyimpan user ID ke shared preferences
  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    print("UserID disimpan ke Shared Preferences: $userId");
  }

  // Mendapatkan user ID dari shared preferences
  Future<int?> getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Logout, hapus token dan userId
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }
}
