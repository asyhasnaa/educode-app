import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/report/screen/view_detail_report.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/report/grade_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportCourseCardWidget extends StatelessWidget {
  const ReportCourseCardWidget({
    super.key,
    required this.courseController,
    required this.gradeReportController,
  });

  final CourseController courseController;
  final GradeReportController gradeReportController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (courseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (courseController.course.isEmpty) {
        return Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsConstant.neutral50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  IconsConstant.onboarding1,
                  height: 130,
                ),
                Text(
                  'Tidak ada course yang diambil',
                  style: TextStylesConstant.nunitoCaptionBold,
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: courseController.course.length,
        physics: const BouncingScrollPhysics(), // Untuk pengguliran yang halus
        shrinkWrap: true, // Menyesuaikan tinggi berdasarkan konten
        itemBuilder: (context, index) {
          final course = courseController.course[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              color: ColorsConstant.white,
              shadowColor: ColorsConstant.neutral300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: AssetImage(IconsConstant.courseimg),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.displayname,
                            style: TextStylesConstant.nunitoCaptionBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Category: ${course.category}',
                            style: TextStylesConstant.nunitoFooter,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        // Progress bar
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: course.progress / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    ColorsConstant.green200),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${course.progress.toInt()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GlobalButtonWidget(
                          text: 'Lihat Nilai',
                          onTap: () {
                            // Mengakses selectedUserId dari CourseController
                            final userId =
                                courseController.selectedUserId.value;

                            // Navigasi ke DetailGradeReportScreen
                            Get.to(() => DetailGradeReportScreen(
                                  courseId: course.id,
                                  courseTitle: course.fullname,
                                  category: course.category,
                                  userId: userId,
                                ));
                          },
                          buttonColor: ColorsConstant.secondary300,
                          textColor: ColorsConstant.black,
                          buttonHeight: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
