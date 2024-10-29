import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/course/detail_screen.dart';
import 'package:educode/view_model/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseCardWidget extends StatelessWidget {
  const CourseCardWidget({
    super.key,
    required this.courseController,
  });

  final CourseController courseController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (courseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (courseController.course.isEmpty) {
        return const Center(child: Text('No courses available'));
      }

      return SizedBox(
        height: 250,
        child: ListView.builder(
          itemCount: courseController.course.length,
          controller: PageController(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final course = courseController.course[index];
            return Padding(
              padding: EdgeInsets.only(
                left:
                    index == 0 ? 16 : 0, // padding left hanya pada item pertama
                right: 2, // padding right di semua item
              ),
              child: SizedBox(
                width: 210,
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
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            ColorsConstant.green200),
                                    borderRadius: BorderRadius.circular(8),
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
                              text: 'Detail Course}',
                              onTap: () {
                                Get.to(() => CourseDetailScreen(
                                      courseId: course.id,
                                      courseTitle: course.fullname,
                                      category: course.category,
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
              ),
            );
          },
        ),
      );
    });
  }
}
