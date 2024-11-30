import 'package:get/get.dart';
import 'package:educode/models/api_response/detail_course_response.dart';
import 'package:educode/services/api_detail_course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailCourseController extends GetxController {
  final ApiDetailCourseService apiDetailCourseService;

  DetailCourseController({required this.apiDetailCourseService});

  var courseDetail = <DetailCourseResponse>[].obs;
  var isLoading = false.obs;

  // Fetch data dari API
  Future<void> fetchDetailCourse(int courseId) async {
    isLoading.value = true;
    try {
      final data = await ApiDetailCourseService().getCourseDetail(courseId);
      if (data != null) {
        courseDetail.assignAll(data);
      } else {
        Get.snackbar('Error', 'Gagal mengambil data detail course');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
