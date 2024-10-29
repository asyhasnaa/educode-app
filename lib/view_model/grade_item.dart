import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:educode/services/api_grade_item_service.dart';
import 'package:get/get.dart';

class GradeItemController extends GetxController {
  final ApiGradeItemService apiGradeItemService;

  GradeItemController({required this.apiGradeItemService});

  var gradeItem = <GradeItem>[].obs; // Menggunakan tipe GradeItem
  var isLoading = false.obs;

  // Fetch data dari API
  Future<void> fetchGradeItem(int courseId) async {
    isLoading.value = true;
    try {
      final data = await apiGradeItemService
          .getUserGrades(courseId); // Masukkan courseId
      if (data != null) {
        gradeItem.assignAll(
            data.gradeItems); // Menggunakan data.gradeItems yang sesuai
      } else {
        Get.snackbar('Error', 'Failed to fetch course details');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
