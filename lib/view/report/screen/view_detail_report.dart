import 'package:educode/global_widgets/sliver_app_bar_widget.dart';
import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/services/api_grade_item_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailGradeReportScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final int category;
  final int userId;
  const DetailGradeReportScreen(
      {super.key,
      required this.courseId,
      required this.courseTitle,
      required this.category,
      required this.userId});

  @override
  _DetailGradeReportScreenState createState() =>
      _DetailGradeReportScreenState();
}

class _DetailGradeReportScreenState extends State<DetailGradeReportScreen> {
  String? selectedMonth;
  final LoginController loginController = Get.find();
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final ApiGradeReportService apiGradeReportService = ApiGradeReportService();

  String? selectedCourseId;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Fungsi untuk memfilter tugas berdasarkan bulan
  List<GradeReportResponse> filterByMonth(
      List<GradeReportResponse> gradeItems) {
    if (selectedMonth == null) {
      return gradeItems; // Jika tidak ada bulan yang dipilih, tampilkan semua
    }
    return gradeItems.where((item) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          (item.gradedategraded ?? 0) * 1000);
      var month = DateFormat('MMMM').format(date);
      return month == selectedMonth;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsConstant.neutral100,
        body: FutureBuilder<UserGrades>(
          future: apiGradeReportService.getUserGradesForCourse(
              widget.courseId,
              widget.userId
                  as int), // Ganti courseId dan userId dengan yang diteruskan
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.gradeItems.isEmpty) {
              return const Center(child: Text('No grades found'));
            } else {
              var filteredGradeItems = filterByMonth(snapshot.data!.gradeItems);

              return CustomScrollView(
                slivers: [
                  SliverAppBarWidget(
                    title: 'Laporan Belajar',
                    description: 'Laporan Belajar',
                    backgroundImagePath: 'assets/images/bg_green.png',
                    courseName: '',
                    gradeLevel: 2,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // Row untuk "Current grades" dan Dropdown filter bulan
                              DropdownButton<String>(
                                dropdownColor: ColorsConstant.neutral50,
                                value: selectedMonth,
                                underline: Container(
                                  color: Colors.transparent,
                                ),
                                hint: const Text('Bulan'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMonth = newValue;
                                  });
                                },
                                items: months.map<DropdownMenuItem<String>>(
                                    (String month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(month),
                                  );
                                }).toList(),
                              ),
                              const Divider(),
                              // Daftar nilai (grade items)
                              Text(
                                'Lihat Nilai Anak',
                                style: TextStylesConstant.nunitoHeading20,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredGradeItems.length,
                                itemBuilder: (context, index) {
                                  final gradeItem = filteredGradeItems[index];
                                  String formatGrade(String? grade) {
                                    if (grade != null) {
                                      final parsedGrade =
                                          double.tryParse(grade);
                                      if (parsedGrade != null) {
                                        return parsedGrade.toStringAsFixed(
                                            parsedGrade.truncateToDouble() ==
                                                    parsedGrade
                                                ? 0
                                                : 2);
                                      }
                                    }
                                    return grade ?? '-';
                                  }

                                  return Card(
                                    color: ColorsConstant.neutral50,
                                    elevation: 0,
                                    clipBehavior: Clip.antiAlias,
                                    borderOnForeground: false,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors
                                                .transparent), // Hilangkan divider

                                        child: ExpansionTile(
                                          childrenPadding:
                                              const EdgeInsets.all(2),
                                          iconColor: ColorsConstant.primary300,
                                          collapsedIconColor:
                                              ColorsConstant.primary300,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorsConstant
                                                      .secondary200,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    formatGrade(gradeItem
                                                        .gradeFormatted),
                                                    style: TextStylesConstant
                                                        .nunitoHeading18
                                                        .copyWith(
                                                      color: ColorsConstant
                                                          .neutral800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  gradeItem.itemName ??
                                                      'No name',
                                                  style: TextStylesConstant
                                                      .nunitoHeading16
                                                      .copyWith(
                                                    color: ColorsConstant
                                                        .neutral900,
                                                  ),
                                                  maxLines:
                                                      3, // Batasi jumlah baris jika diperlukan
                                                  overflow: TextOverflow
                                                      .visible, // Hindari overflow
                                                  softWrap:
                                                      true, // Izinkan pembungkusan teks
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Catatan Guru:',
                                                        style: TextStylesConstant
                                                            .nunitoHeading16,
                                                      ),
                                                      Text(gradeItem.feedback ??
                                                          'No feedback'),
                                                    ],
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(8),
                          height: 200,
                          decoration: BoxDecoration(
                              color: ColorsConstant.primary100,
                              boxShadow: const [
                                BoxShadow(
                                  color: ColorsConstant.neutral300,
                                  blurRadius: 20,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage("assets/images/Banner2.png"),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
