import 'package:educode/global_widgets/sliver_app_bar_widget.dart';
import 'package:educode/models/api_response/detail_course_response.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_detail_course_service.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/course/detail_course_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailScreen extends StatelessWidget {
  final int courseId;
  final String courseTitle;
  final int category;
  final int userId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.category,
    required this.userId,
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
    // courseController.fetchUserCourse( );

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
                SliverAppBarWidget(
                    title: "Coding Construct",
                    description: "Detail Course",
                    courseName: courseTitle,
                    gradeLevel: category,
                    backgroundImagePath: "assets/images/bg_green.png"),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            if (kDebugMode) {
                              print('Summary: ${courseDetail.summary}');
                            }
                            if (kDebugMode) {
                              print('Tanggal yang ditemukan: $date');
                            }
                            if (kDebugMode) {
                              print('URL gambar yang ditemukan: $imageUrl');
                            }

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
                                      style:
                                          TextStylesConstant.nunitoHeading18),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        children: [
                                          // Tampilkan teks summary yang sudah diparse
                                          Text(
                                            'Tanggal: $date',
                                            style: TextStylesConstant
                                                .nunitoCaptionBold,
                                          ),
                                          const SizedBox(height: 8),
                                          FutureBuilder<String?>(
                                            future: loginService.getToken(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError ||
                                                  snapshot.data == null) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/no_image.png', // Path gambar "no image"
                                                      height: 150,
                                                      width: 150,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Text(
                                                      'Gambar tidak ditemukan',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                final imageUrlWithToken =
                                                    '$imageUrl?token=${ApiRoutes.wstoken}';

                                                return imageUrl.isNotEmpty
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Image.network(
                                                          imageUrlWithToken,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child; // Gambar selesai dimuat
                                                            }
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          },
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/no_image.png', // Gambar fallback
                                                                  height: 150,
                                                                  width: 150,
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                const Text(
                                                                  'Gambar tidak ditemukan',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
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
                                          style: TextStylesConstant
                                              .nunitoHeading16,
                                        ),
                                        subtitle: isAssignment
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Opened : ${_getDataFromModule(module, "Opened:")}",
                                                    style: TextStylesConstant
                                                        .nunitoFooterSemiBold,
                                                  ),
                                                  Text(
                                                    "Due : ${_getDataFromModule(module, "Due:")}",
                                                    style: TextStylesConstant
                                                        .nunitoFooterSemiBold,
                                                  ),
                                                ],
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
