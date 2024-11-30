// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:educode/view_model/course/course_controller.dart';
// import 'package:educode/view_model/schedule/schedule_controller.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeController extends GetxController {
//   var children = [].obs;
//   RxInt selectedUserId = 0.obs;

//   @override
//   void onInit() async {
//     super.onInit();
//     await initializeSelectedChild();
//     ever(selectedUserId, (int id) {
//       // Perbarui jadwal dan course setiap kali ID berubah
//       Get.find<CourseController>().fetchUserCourse(id);
//       final selectedChildName = children.firstWhere(
//           (child) => child['childId'] == id,
//           orElse: () => null)?['name'];
//       if (selectedChildName != null) {
//         Get.find<ScheduleController>().fetchScheduleForChild(selectedChildName);
//       }
//     });
//   }

//   void setSelectedUserId(int childId) {
//     selectedUserId.value = childId;
//     SharedPreferencesHelper.saveSelectedChildId(childId);
//   }

//   Future<void> initializeSelectedChild() async {
//     final savedChildId = await SharedPreferencesHelper.getSelectedChildId();
//     if (savedChildId != null) {
//       selectedUserId.value = savedChildId;
//     } else if (children.isNotEmpty) {
//       setSelectedUserId(children.first['childId']); // Set default anak pertama
//     }
//   }
// }

// class SharedPreferencesHelper {
//   static const String selectedChildKey = 'selectedChildId';

//   static Future<void> saveSelectedChildId(int childId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(selectedChildKey, childId);
//   }

//   static Future<int?> getSelectedChildId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(selectedChildKey);
//   }
// }
