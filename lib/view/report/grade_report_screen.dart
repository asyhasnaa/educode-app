import 'package:educode/global_widgets/child_dropdown_widget.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_grade_item_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/report/widget/course_card_widget.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';
import 'package:educode/view_model/report/grade_item.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradeReportScreen extends StatelessWidget {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final GradeReportController gradeReportController = Get.put(
    GradeReportController(ApiGradeReportService()),
  );
  final InvoiceController invoiceController = Get.put(InvoiceController());
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Belajar',
          style: TextStylesConstant.nunitoHeading20,
        ),
        backgroundColor: ColorsConstant.neutral100,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: ColorsConstant.neutral100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                // Cek apakah data anak sudah tersedia
                if (loginController.children.isEmpty) {
                  return const Center(child: Text("No children found"));
                } else {
                  // cek selectedUserId cocok dengan salah satu childId di `children
                  int? selectedChildId = loginController.selectedUserId.value;

                  // Validasi jika `selectedChildId` tidak ada di dalam daftar children,
                  if (!loginController.children
                      .any((child) => child['childId'] == selectedChildId)) {
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
                          courseController.fetchUserCourse(childId);
                        },
                      ));
                }
              }),
              ReportCourseCardWidget(
                courseController: courseController,
                gradeReportController: gradeReportController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
