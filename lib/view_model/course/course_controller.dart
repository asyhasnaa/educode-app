import 'package:educode/models/api_response/course_response.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/home/home_controller.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  final ApiCourseService apiCourseService;
  CourseController({required this.apiCourseService});
  final LoginController loginController = Get.find<LoginController>();
  // final HomeController homeController = Get.put(HomeController());
  var course = <CourseUserResponse>[].obs;
  var isLoading = false.obs;
  final RxList<String> courseNames = <String>[].obs;
  RxInt selectedUserId = 0.obs;
  RxInt userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNameCourse();
    ever(loginController.selectedUserId,
        (value) => fetchUserCourse(selectedUserId.value));

    // Jika sudah ada nilai `selectedUserId`, fetch kursus untuk anak tersebut
    if (loginController.selectedUserId.value != 0) {
      fetchUserCourse(loginController.selectedUserId.value);
    }
  }

  //Metode untuk mendapatkan data course sesuai ID Anak
  Future<void> fetchUserCourse(int userId) async {
    isLoading.value = true;

    print(
        "==========Fetching courses for User ID: $userId (Type: ${userId.runtimeType})");

    try {
      final userCourse = await apiCourseService.getCourse(userId);

      if (userCourse != null) {
        course.assignAll(userCourse);
        print("========Courses fetched: ${userCourse.length} courses");
        print("========Courses fetched: ${userCourse} courses");
      } else {
        course.clear();
        Get.snackbar('Error', 'Failed to fetch user course');
      }
    } catch (e) {
      print("Error ambil course: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Metode untuk mengupdate ID anak yang dipilih
  void updateSelectedUserId(int childId) {
    selectedUserId.value = childId;
    fetchUserCourse(childId);
  }

  //Metode untuk mendapatkan semua data course di Moodle
  Future<void> fetchAllNameCourse() async {
    isLoading.value = true;

    try {
      final names = await apiCourseService.getAllCourses();

      if (names.isNotEmpty) {
        courseNames.assignAll(names);
        print("Nama kursus berhasil diambil: ${courseNames.length} kursus");
      } else {
        print("Tidak ada nama kursus yang ditemukan.");
      }
    } catch (e) {
      print("Gagal memuat nama kursus: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
