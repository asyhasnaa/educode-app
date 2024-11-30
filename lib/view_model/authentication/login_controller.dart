import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/global_widgets/navbar_admin_screen.dart';
import 'package:educode/global_widgets/navbar_ortu_screen.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final ApiAuthService _apiAuthService = ApiAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var token = ''.obs;
  var userId = 0.obs;
  var children = [].obs;
  RxInt selectedUserId = 0.obs;

  Rx<String?> passwordErrorText = Rx<String?>(null);
  Rx<String?> emailErrorText = Rx<String?>(null);
  Rx<bool> isFormValid = Rx<bool>(false);
  Rx<bool> obscureText = true.obs;
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<String?> errorMessage = Rx<String?>(null);
  Rx<String> selectedRole = ''.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void onInit() async {
    usernameFocusNode.addListener(() => update());
    passwordFocusNode.addListener(() => update());
    usernameController.addListener(validateForm);
    passwordController.addListener(validateForm);
    super.onInit();
    await initializeSelectedChild();
    _checkToken();
    // Listener untuk perubahan nilai `selectedUserId`
    ever(selectedUserId, (int id) {
      // Perbarui jadwal dan course setiap kali ID berubah
      Get.find<CourseController>().fetchUserCourse(id);
      final selectedChildName = children.firstWhere(
          (child) => child['childId'] == id,
          orElse: () => null)?['name'];
      if (selectedChildName != null) {
        Get.find<ScheduleController>().fetchScheduleForChild(selectedChildName);
      }
    });
  }

  //Method Login
  Future<void> postLogin() async {
    isLoading.value = true;

    if (selectedRole.value == 'Orangtua') {
      // Login menggunakan Moodle API
      await _loginWithMoodle();
    } else if (selectedRole.value == 'Admin') {
      // Login menggunakan Firebase
      await _loginWithFirebase();
    } else {
      Get.snackbar('Error', 'Silahkan pilih peran anda');
    }

    isLoading.value = false;
    clearForm();
  }

  //Metode Login menggunakan Moodle API
  Future<void> _loginWithMoodle() async {
    try {
      final loginResponse = await _apiAuthService.loginApp(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (loginResponse != null && loginResponse.token.isNotEmpty) {
        token.value = loginResponse.token;
        final siteInfoResponse = await _apiAuthService.fetchUserId(token.value);

        if (siteInfoResponse != null) {
          userId.value = siteInfoResponse.userid;
          await _apiAuthService.saveUserId(userId.value);
          await checkUserInFirebase();

          Get.to(() => const NavBarOrtuScreen());
        } else {
          showLoginFailedDialog(errorMessage.value ?? '');
        }
      } else {
        showLoginFailedDialog(errorMessage.value ?? '');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      showLoginFailedDialog(errorMessage.value ?? '');
    }
  }

  //Metode Login menggunakan Firebase
  Future<void> _loginWithFirebase() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Login sukses, arahkan ke halaman admin
      Get.to(() => const NavBarAdminScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    }
  }

  void validatePassword(String value) {
    passwordErrorText.value = value.length < 6
        ? 'Kata sandi harus terdiri dari minimal 6 karakter'
        : null;
    validateForm();
  }

  void validateForm() {
    isFormValid.value = passwordErrorText.value == null &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void clearForm() {
    usernameController.clear();
    passwordController.clear();
    passwordErrorText.value = null;
    isFormValid.value = false;
    selectedRole.value = '';
  }

  void showLoginFailedDialog(String errorMessage) {
    Get.defaultDialog(
      backgroundColor: ColorsConstant.white,
      title: 'Ups, Gagal Masuk!',
      titleStyle: TextStylesConstant.nunitoHeading24.copyWith(
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          left: 24,
          right: 24,
        ),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStylesConstant.nunitoCaption16.copyWith(
            color: ColorsConstant.neutral600,
          ),
        ),
      ),
      confirm: InkWell(
        onTap: () {
          Get.back();
        },
        child: Ink(
          width: 250,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorsConstant.primary300,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Center(
            child: GlobalButtonWidget(
              text: 'Masuk Kembali',
              onTap: () {
                Get.back();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkToken() async {
    String? token = await _apiAuthService.getToken();
    if (token != null) {
      print("Token ditemukan di Shared Preferences: $token");
      // Lakukan navigasi ke layar utama atau yang sesuai
    } else {
      print("Token tidak ditemukan, pengguna perlu login.");
      // Navigasi ke layar login jika diperlukan
    }
  }

  //CHECK USERID IN FIREBASE
  Future<void> checkUserInFirebase() async {
    try {
      // Query dokumen user berdasarkan userId dari Moodle
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.value.toString())
          .get();

      if (userDoc.exists) {
        // Jika user ditemukan, ambil data anak (children)
        final data = userDoc.data();
        children.value = data?['children'] ?? [];
        print("Children list: ${children.value}");
      } else {
        Get.snackbar('Error', 'User not found in Firebase');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch children: $e');
    }
  }

  void setSelectedUserId(int childId) {
    selectedUserId.value = childId;
    SharedPreferencesHelper.saveSelectedChildId(childId);
  }

  Future<void> initializeSelectedChild() async {
    final savedChildId = await SharedPreferencesHelper.getSelectedChildId();
    if (savedChildId != null) {
      selectedUserId.value = savedChildId;
    } else if (children.isNotEmpty) {
      setSelectedUserId(children.first['childId']); // Set default anak pertama
    }
  }
}

class SharedPreferencesHelper {
  static const String selectedChildKey = 'selectedUserId';

  static Future<void> saveSelectedChildId(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(selectedChildKey, childId);
  }

  static Future<int?> getSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(selectedChildKey);
  }
}
