import 'package:educode/models/api_response/course_response.dart';
import 'package:educode/services/api_course.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  final ApiCourseService apiCourseService;

  CourseController({required this.apiCourseService});

  var course = <CourseUserResponse>[].obs;
  var isLoading = false.obs;

  Future<void> fetchUserCourse() async {
    isLoading.value = true;

    try {
      final userCourse = await apiCourseService.getCourse();

      if (userCourse != null) {
        course.assignAll(userCourse);
      } else {
        Get.snackbar('Error', 'Failed to fetch user course');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occured: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
