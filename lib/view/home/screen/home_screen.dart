import 'package:educode/global_widgets/child_dropdown_widget.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/home/widget/course_card_widget.dart';
import 'package:educode/view/home/widget/schedule_card_widget.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/home/home_controller.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final InvoiceController invoiceController = Get.put(InvoiceController());
  int _currentPage = 0;
  final PageController _pageController = PageController();
  // final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    // _loadSelectedUserId();
    loginController.initializeSelectedChild();
  }

  Future<void> _loadSelectedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChildId =
        prefs.getInt('selectedUserId'); //load Id anak yang dipilih

    if (savedChildId != null &&
        loginController.children
            .any((child) => child['child'] == savedChildId)) {
      //Jika Id ditemukan
      loginController.selectedUserId(savedChildId);
      _updateDataForChild(savedChildId);
    } else if (loginController.children.isNotEmpty) {
      //Jika Id tidak ditemukan, tetapi ada data anak
      final firstChildId = loginController.children.first['childId'];
      loginController.setSelectedUserId(firstChildId);
    }
  }

  Future<void> _saveSelectedUserId(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedUserId', childId);
  }

  //Perbarui data course dan jadwal anak
  void _updateDataForChild(int childId) {
    // Perbarui data setiap kali `selectedUserId` berubah
    ever(loginController.selectedUserId, (userId) {
      if (userId != null) {
        final selectedChildId = loginController.selectedUserId.value;
        final selectedChildName = loginController.children
            .firstWhere((child) => child['childId'] == selectedChildId)['name'];

        if (selectedChildId != null || selectedChildName != null) {
          courseController.fetchUserCourse(selectedChildId);
          scheduleController.fetchScheduleForChild(selectedChildName);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController(
      apiProfileService: ApiProfileService(),
    ));
    final loginController = Get.find<LoginController>();
    profileController.fetchUserProfile();
    final selectedChildId = loginController.selectedUserId.value;
    final selectedChildName = loginController.children
        .firstWhere((child) => child['childId'] == selectedChildId)['name'];

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
                            "Selamat Datang, \n${profileController.profile.value.fullname}!",
                            style: TextStylesConstant.nunitoHeading20
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
                  child: Obx(() {
                    // Cek apakah data anak sudah tersedia
                    if (loginController.children.isEmpty) {
                      return const Center(child: Text("No children found"));
                    } else {
                      // cek selectedUserId cocok dengan salah satu childId di `children
                      int? selectedChildId =
                          loginController.selectedUserId.value;

                      // Validasi jika `selectedChildId` tidak ada di dalam daftar children,
                      if (!loginController.children.any(
                          (child) => child['childId'] == selectedChildId)) {
                        selectedChildId = null;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ChildDropdownWidget(
                          onChildChanged: (childId) {
                            // Perbarui data khusus HomeScreen jika diperlukan
                            loginController.selectedUserId.value = childId;
                            courseController.fetchUserCourse(childId);

                            scheduleController
                                .fetchScheduleForChild(selectedChildName);
                            // Simpan pilihan ke SharedPreferences
                            _saveSelectedUserId(childId);
                          },
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(
                  height: 16,
                ),
                bannerListWidget(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        List.generate(3, (index) => buildDot(index, context)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Jadwal belajar hari ini',
                    style: TextStylesConstant.nunitoHeading18
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ScheduleCardWidget(
                    childName: selectedChildName,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Daftar course yang diambil',
                      style: TextStylesConstant.nunitoHeading18
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Obx(() {
                  if (courseController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CourseCardWidget(
                    courseController: courseController,
                  );
                }),
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

  Container bannerListWidget() {
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

  Container buildDot(int index, BuildContext context) {
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
