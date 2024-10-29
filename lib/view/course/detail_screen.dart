import 'package:educode/global_widgets/app_bar_widget.dart';
import 'package:educode/models/api_response/detail_course_response.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_detail_course_service.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/course_controller.dart';
import 'package:educode/view_model/detail_course_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailScreen extends StatelessWidget {
  final int courseId;
  final String courseTitle;
  final int category;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final DetailCourseController detailCourseController = Get.put(
        DetailCourseController(
            apiDetailCourseService: ApiDetailCourseService()));
    final CourseController courseController =
        Get.put(CourseController(apiCourseService: ApiCourseService()));
    final course = courseController.course;
    final ApiAuthService loginService = ApiAuthService();
    detailCourseController.fetchDetailCourse(courseId);
    courseController.fetchUserCourse();

    detailCourseController.fetchDetailCourse(courseId);

    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      body: Obx(
        () {
          if (detailCourseController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (detailCourseController.courseDetail.isEmpty) {
            return const Center(
                child: Text('Tidak ada data detail course yang tersedia'));
          } else {
            final courseDetails = detailCourseController.courseDetail;
            final course = courseController.course;
            return CustomScrollView(
              slivers: [
                AppBarWidget(
                    title: "Coding Construct",
                    description: "Detail Course",
                    courseName: courseTitle,
                    gradeLevel: category,
                    backgroundImagePath: "assets/images/bg_green.png"),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Teacher : Aisyah Hasna Aulia",
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.description),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Deskripsi : Detail course di sini",
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: courseDetails.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final courseDetail = courseDetails[index];

                            // Regex untuk mendapatkan tanggal dan gambar
                            final dateRegex =
                                RegExp(r'(?<=Tanggal:\s)(.*?)(?=<\/p>)');
                            final imgRegex = RegExp(r'src="([^"]+)"');

                            final dateMatch =
                                dateRegex.firstMatch(courseDetail.summary);
                            final imgMatch =
                                imgRegex.firstMatch(courseDetail.summary);

                            final date = dateMatch?.group(0) ?? 'Unknown Date';
                            final imageUrl = imgMatch?.group(1) ?? '';

                            // Debugging: print ke log untuk melihat hasil regex
                            print('Summary: ${courseDetail.summary}');
                            print('Tanggal yang ditemukan: $date');
                            print('URL gambar yang ditemukan: $imageUrl');

                            return Card(
                              color: ColorsConstant.white,
                              shadowColor: ColorsConstant.neutral300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ExpansionTile(
                                  title: Text(courseDetail.name,
                                      style: TextStylesConstant.nunitoHeading5),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        children: [
                                          // Tampilkan teks summary yang sudah diparse
                                          Text('Tanggal: $date'),
                                          const SizedBox(height: 8),
                                          // Image.network(
                                          //     'https://lms.educode.id/webservice/pluginfile.php/160/course/section/80/image.png?token=eb60c3bda800422e20df49087f462e81'),

                                          // Menggunakan FutureBuilder untuk menampilkan gambar dengan token
                                          FutureBuilder<String?>(
                                            future: loginService.getToken(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError ||
                                                  snapshot.data == null) {
                                                return const Text(
                                                    'Gambar tidak tersedia');
                                              } else {
                                                final token = snapshot.data;
                                                final imageUrlWithToken =
                                                    '$imageUrl?token=$token';

                                                return imageUrl.isNotEmpty
                                                    ? Image.network(
                                                        imageUrlWithToken,
                                                      )
                                                    : const Text('ii');
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                    // Menampilkan modul
                                    ...courseDetail.modules.map((module) {
                                      bool isAssignment =
                                          module.modname == "assign";
                                      String dueDate = '';
                                      String openDate = '';

                                      return ListTile(
                                        leading: Icon(
                                          isAssignment
                                              ? Icons.assignment
                                              : Icons.book,
                                          color: isAssignment
                                              ? ColorsConstant.warning600
                                              : ColorsConstant.primary200,
                                        ),
                                        title: Text(
                                          module.name,
                                          style:
                                              TextStylesConstant.nunitoHeading6,
                                        ),
                                        subtitle: isAssignment
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Text(
                                                      "Opened : ${_getDataFromModule(module, "Opened:")}"),
                                                  Text(
                                                      "Due : ${_getDataFromModule(module, "Due:")}"),
                                                ],
                                              )
                                            : null,
                                        trailing: isAssignment
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Done",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : null,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ]))
              ],
            );
          }
        },
      ),
    );
  }

  String _getDataFromModule(module, label) {
    final dateObj = module.dates.firstWhere(
      (date) => date.label == label,
      orElse: () => Date(label: 'Unknown Date', timestamp: 0),
    );

    if (dateObj != null) {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(dateObj.timestamp * 1000);
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } else {
      return 'Unknown Date';
    }
  }
}
