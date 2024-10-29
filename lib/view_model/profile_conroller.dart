import 'package:educode/models/api_response/profile_model.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ApiProfileService apiProfileService;

  ProfileController({
    required this.apiProfileService,
  });

  var profile = ProfileUserResponse().obs;
  var isLoading = false.obs;

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      final profileResponse = await apiProfileService.getProfile();
      profile.value = profileResponse!;
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
