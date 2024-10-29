import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/widget/bill_card_widget.dart';
import 'package:educode/view/schedule/widget/card_schedule_widget.dart';
import 'package:educode/view_model/course_controller.dart';
import 'package:educode/view_model/login_controller.dart';
import 'package:educode/view_model/profile_conroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final LoginController loginController = Get.find();
  final ProfileController profileController =
      Get.put(ProfileController(apiProfileService: ApiProfileService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        '${profileController.profile.value.profileimageurl}, ',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Selamat Datang, \n${profileController.profile.value.firstname}!",
                      style: TextStylesConstant.nunitoHeading6
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
                );
              }),
              const SizedBox(
                height: 24,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Jadwal Hari ini'),
                TextButton(onPressed: () {}, child: const Text("Lihat Semua"))
              ]),
              const SizedBox(
                height: 10,
              ),
              const CardScheduleWidget(),
              const SizedBox(
                height: 24,
              ),
              const Text('Daftar Tagihan'),
              const SizedBox(
                height: 10,
              ),
              BillCardWidget(
                  bulan: "Januari",
                  namaAnak: "Gerard",
                  jumlah: 300.000,
                  status: "Lunas",
                  onTap: () {})
            ],
          ),
        ),
      )),
    );
  }
}
