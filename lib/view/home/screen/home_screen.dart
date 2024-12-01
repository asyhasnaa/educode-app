import 'package:educode/global_widgets/child_dropdown_widget.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/home/widget/course_card_widget.dart';
import 'package:educode/view/home/widget/schedule_card_widget.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/home/home_controller.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final HomeController homeController = Get.put(HomeController(
      courseController:
          CourseController(apiCourseService: ApiCourseService())));

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(
      ProfileController(apiProfileService: ApiProfileService()),
    );

    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian profil
                Obx(() {
                  if (profileController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final profile = profileController.profile.value;
                  return profile.fullname == null
                      ? const Center(child: Text('No profile available'))
                      : _buildProfileWidget(profile);
                }),
                const SizedBox(height: 16),

                // Dropdown anak
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    if (homeController.loginController.children.isEmpty) {
                      return const Center(child: Text("No children found"));
                    }
                    return ChildDropdownWidget(
                      onChildChanged: (childId) {
                        homeController.saveSelectedUserId(childId);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Banner
                bannerListWidget(),
                const SizedBox(height: 16),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3, // Jumlah banner
                      (index) => buildDot(index, context),
                    ),
                  );
                }),
                // Jadwal belajar
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Jadwal belajar hari ini',
                    style: TextStylesConstant.nunitoHeading18
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Obx(() {
                  final selectedChildName =
                      homeController.loginController.children.firstWhere(
                    (child) =>
                        child['childId'] == homeController.selectedUserId.value,
                    orElse: () => null,
                  )?['name'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ScheduleCardWidget(
                      childName: selectedChildName ?? 'Tidak ada anak terpilih',
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Daftar course
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Daftar course yang diambil',
                    style: TextStylesConstant.nunitoHeading18
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(() {
                  if (homeController.courseController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CourseCardWidget(
                    courseController: homeController.courseController,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileWidget(profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profile.profileimageurl ?? ''),
          ),
          const SizedBox(width: 13),
          Text(
            "Selamat Datang, \n${profile.fullname}!",
            style: TextStylesConstant.nunitoHeading20
                .copyWith(color: ColorsConstant.black),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              IconsConstant.notification1,
              color: ColorsConstant.secondary300,
              height: 26,
              width: 26,
            ),
          ),
        ],
      ),
    );
  }

  // Banner widget
  Widget bannerListWidget() {
    return Container(
      height: 200.0,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: ColorsConstant.neutral200,
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ]),
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.95),
        itemCount: 3,
        onPageChanged: (int page) {
          homeController.currentPage.value = page; // update current page
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/Banner${index + 1}.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

// Memperbaiki pemanggilan buildDot
  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: homeController.currentPage.value == index
          ? 30
          : 10, // Akses currentPage.value
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: homeController.currentPage.value == index
            ? ColorsConstant.primary300
            : ColorsConstant.neutral400, // Akses currentPage.value
      ),
    );
  }
}
