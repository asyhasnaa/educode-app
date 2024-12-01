import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/schedule/screen/adm_input_schedule_screen.dart';
import 'package:educode/view/schedule/screen/adm_show_schedule_screen.dart';
import 'package:educode/view/schedule/widget/adm_card_schedule_widget.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class AdminHomeScreen extends StatelessWidget {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final LoginController loginController = Get.find();
  final ProfileController profileController =
      Get.put(ProfileController(apiProfileService: ApiProfileService()));
  final InvoiceController invoiceController = Get.put(InvoiceController());
  final ScheduleController scheduleController = Get.put(ScheduleController());

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(IconsConstant.logo),
                    ),
                    const SizedBox(width: 13),
                    Text(
                      "Selamat Datang, \nAdministrator!",
                      style: TextStylesConstant.nunitoHeading20
                          .copyWith(color: ColorsConstant.black),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Recapt Tagihan',
                  style: TextStylesConstant.nunitoHeading18,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final summary = invoiceController.getInvoiceSummary();
                  return _buildSummaryWidget(summary);
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jadwal Hari ini',
                      style: TextStylesConstant.nunitoHeading18,
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => AdminShowSchedule()),
                      child: Text(
                        "Lihat Semua",
                        style: TextStylesConstant.nunitoCaption16
                            .copyWith(color: ColorsConstant.neutral600),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorsConstant.neutral50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorsConstant.neutral200,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DatePicker(
                      locale: 'id',
                      DateTime.now().subtract(const Duration(days: 2)),
                      monthTextStyle: TextStylesConstant.nunitoFooterBold,
                      dateTextStyle: TextStylesConstant.nunitoHeading16
                          .copyWith(fontWeight: FontWeight.bold),
                      dayTextStyle: TextStylesConstant.nunitoFooterBold,
                      initialSelectedDate: selectedDate.value,
                      selectionColor: ColorsConstant.secondary300,
                      selectedTextColor: ColorsConstant.white,
                      daysCount: 6,
                      onDateChange: (date) {
                        selectedDate.value = date;
                        scheduleController.fetchScheduleForAdmin(date);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Obx(() {
                  if (scheduleController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (scheduleController.schedules.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorsConstant.neutral50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: ColorsConstant.neutral300, blurRadius: 20),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              IconsConstant.noSchedule,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Tidak ada jadwal untuk hari ini.',
                              style: TextStylesConstant.nunitoCaption16,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    child: AdminScheduleCardWidget(),
                    onTap: () {
                      final selectedSchedule = scheduleController.schedules
                          .firstWhere(
                              (schedule) =>
                                  schedule['date'] ==
                                  selectedDate.value.toIso8601String(),
                              orElse: () => {});
                      Get.to(() => InputScheduleScreen(
                            scheduleData: selectedSchedule,
                            isEditMode: true,
                          ));
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.secondary300,
        onPressed: () => Get.to(() => const InputScheduleScreen()),
        child: const Icon(
          Icons.add,
          color: ColorsConstant.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSummaryWidget(Map<String, int> summary) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_green.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryColumn('Lunas', summary['paid']!, Colors.white),
          _buildSummaryColumn('Belum Bayar', summary['unpaid']!, Colors.white),
          _buildSummaryColumn('Total', summary['total']!, Colors.white),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String label, int count, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStylesConstant.nunitoHeading24.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStylesConstant.nunitoHeading16.copyWith(color: textColor),
        ),
      ],
    );
  }
}
