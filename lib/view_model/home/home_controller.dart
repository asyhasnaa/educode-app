import 'package:educode/services/api_course.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final ScheduleController scheduleController = Get.put(ScheduleController());

  HomeController({required CourseController courseController});

  var selectedUserId = 0.obs;
  var currentPage = 0.obs; // Tambahkan variabel currentPage

  void updatePage(int page) {
    currentPage.value = page; // Fungsi untuk memperbarui currentPage
  }

  @override
  void onInit() {
    super.onInit();
    initializeSelectedChild();
  }

  Future<void> initializeSelectedChild() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChildId = prefs.getInt('selectedUserId');

    if (savedChildId != null &&
        loginController.children
            .any((child) => child['childId'] == savedChildId)) {
      selectedUserId.value = savedChildId;
    } else if (loginController.children.isNotEmpty) {
      selectedUserId.value = loginController.children.first['childId'];
    }

    updateDataForChild(selectedUserId.value);
  }

  void updateDataForChild(int childId) {
    final childName = loginController.children
        .firstWhere((child) => child['childId'] == childId)['name'];
    courseController.fetchUserCourse(childId);
    scheduleController.fetchScheduleForChild(childName);
  }

  Future<void> saveSelectedUserId(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedUserId', childId);
    selectedUserId.value = childId;
    updateDataForChild(childId);
  }
}
