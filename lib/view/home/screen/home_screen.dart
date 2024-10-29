import 'dart:developer';

import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/home/widget/course_card_widget.dart';
import 'package:educode/view/home/widget/schedule_card_widget.dart';
import 'package:educode/view_model/course_controller.dart';
import 'package:educode/view_model/login_controller.dart';
import 'package:educode/view_model/profile_conroller.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final LoginController loginController = Get.find();
  final ProfileController profileController =
      Get.put(ProfileController(apiProfileService: ApiProfileService()));

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    courseController.fetchUserCourse();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> list = [
      'Gerard',
      'Mathhew',
    ];

    final ProfileController profileController = Get.put(ProfileController(
      apiProfileService: ApiProfileService(),
    ));

    profileController.fetchUserProfile();

    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (profileController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (profileController.profile.value.fullname == null) {
                    return const Center(child: Text('No profile available'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                '${profileController.profile.value.profileimageurl}, '),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Text(
                            "Selamat Datang, \n${profileController.profile.value.firstname}!",
                            style: TextStylesConstant.nunitoHeading4
                                .copyWith(color: ColorsConstant.black),
                            textAlign: TextAlign.start,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(IconsConstant.notification1,
                                color: ColorsConstant.secondary300,
                                height: 26,
                                width: 26),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomDropdown<String>(
                    decoration: const CustomDropdownDecoration(
                      closedShadow: [
                        BoxShadow(
                          color: ColorsConstant.neutral200,
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                      closedFillColor: ColorsConstant.white,
                    ),
                    hintText: 'nama anak, ',
                    items: list,
                    initialItem: list[0],
                    onChanged: (value) {
                      log('changing value to: $value');
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                BannerListWidget(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        List.generate(3, (index) => BuildDot(index, context)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Jadwal belajar minggu ini',
                    style: TextStylesConstant.nunitoHeading5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ScheduleCardWidget(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Daftar course saat ini',
                      style: TextStylesConstant.nunitoHeading5
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 8,
                ),
                CourseCardWidget(courseController: courseController),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container BannerListWidget() {
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
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(viewportFraction: 0.95),
            itemCount: 3,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Banner${index + 1}.png', // Sesuaikan dengan indeks banner
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container BuildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 30 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _currentPage == index
              ? ColorsConstant.primary300
              : ColorsConstant.neutral300),
    );
  }
}
