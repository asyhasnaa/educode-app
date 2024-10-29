import 'package:educode/global_widgets/navbar_admin_screen.dart';
import 'package:educode/global_widgets/navbar_ortu_screen.dart';
import 'package:educode/services/api_detail_course_service.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/detail_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ApiAuthService _apiAuthService = ApiAuthService();

  var token = ''.obs;
  var userId = 0.obs;

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
  void onInit() {
    usernameFocusNode.addListener(() => update());
    passwordFocusNode.addListener(() => update());
    usernameController.addListener(validateForm);
    passwordController.addListener(validateForm);
    super.onInit();
    _checkToken();
  }

  Future<void> postLogin() async {
    isLoading.value = true;
    try {
      final loginResponse = await _apiAuthService.loginApp(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (loginResponse != null && loginResponse.token.isNotEmpty) {
        token.value = loginResponse.token;

        // Logging token setelah login
        print("Token setelah login: ${token.value}");

        final siteInfoResponse = await _apiAuthService.fetchUserId(token.value);
        if (siteInfoResponse != null) {
          userId.value = siteInfoResponse.userid;

          final detailCourseController = Get.put(DetailCourseController(
              apiDetailCourseService: ApiDetailCourseService()));
          // detailCourseController.setCredentials(token.value, userId.value);
          // await detailCourseController.fetchDetailCourse();

          if (selectedRole.value == 'Orangtua') {
            Get.to(() => const NavBarOrtuScreen());
          } else if (selectedRole.value == 'Admin') {
            Get.to(() => const NavBarAdminScreen());
          } else {
            Get.snackbar('Error', 'Silahkan pilih peran anda');
          }
        } else {
          Get.snackbar('Error', 'Failed to fetch userId');
        }
      } else {
        Get.snackbar('Login Error', 'Invalid login credentials');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      showLoginFailedDialog(errorMessage.value ?? '');
    } finally {
      isLoading.value = false;
      clearForm();
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
  }

  void showLoginFailedDialog(String errorMessage) {
    Get.defaultDialog(
      backgroundColor: ColorsConstant.white,
      title: 'Gagal Masuk!',
      titleStyle: TextStylesConstant.nunitoHeading3.copyWith(
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
          style: TextStylesConstant.nunitoCaption.copyWith(
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
            child: Text(
              'Masuk Kembali',
              style: TextStylesConstant.nunitoButtonMedium
                  .copyWith(color: ColorsConstant.primary300),
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
}
