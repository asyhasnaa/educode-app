import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:educode/services/api_grade_item_service.dart';
import 'package:get/get.dart';

class GradeReportController extends GetxController {
  final ApiGradeReportService apiGradeReportService;

  GradeReportController(this.apiGradeReportService);

  var gradeReportDetail = <GradeReportResponse>[].obs;
  var isLoading = false.obs;

  // Fetch data dari API
  Future<void> fetchGradeReport(int courseId, int userId) async {
    isLoading.value = true;
    try {
      final data = await ApiGradeReportService()
          .getUserGradesForCourse(courseId, userId);
      gradeReportDetail.assignAll(data.gradeItems);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
