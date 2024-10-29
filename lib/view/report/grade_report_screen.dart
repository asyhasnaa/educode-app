import 'dart:convert';
import 'package:educode/global_widgets/app_bar_widget.dart';
import 'package:educode/models/api_response/grade_item_model.dart';
import 'package:educode/routes/api_routes.dart';
import 'package:educode/services/api_grade_item_service.dart';
import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/grade_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GradeReportScreen extends StatefulWidget {
  const GradeReportScreen({super.key});

  @override
  _GradeReportScreenState createState() => _GradeReportScreenState();
}

class _GradeReportScreenState extends State<GradeReportScreen> {
  String? selectedMonth;
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
  List<GradeItem> filterByMonth(List<GradeItem> gradeItems) {
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

  Future<UserGrades> getUserGrades() async {
    final ApiAuthService loginService = ApiAuthService();

    final token = await loginService.getToken();
    final userid = await loginService.getUserIdFromPrefs();
    if (token == null || userid == null) {
      throw Exception('Token or User ID is null');
    }

    final response = await http.get(
      Uri.parse(
          'https://lms.educode.id/webservice/rest/server.php?wstoken=eb60c3bda800422e20df49087f462e81&moodlewsrestformat=json&wsfunction=gradereport_user_get_grade_items&courseid=4&userid=10'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      var userGradesJson =
          json['usergrades'][0]; // Mengakses objek 'usergrades'
      return UserGrades.fromJson(userGradesJson); // Parsing menggunakan model
    } else {
      throw Exception('Failed to load grades');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      body: FutureBuilder<UserGrades>(
        future: getUserGrades(),
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
                const AppBarWidget(
                  title: 'Laporan Belajar',
                  description: 'Laporan Belajar',
                  courseName: 'Construct C++',
                  gradeLevel: 1,
                  backgroundImagePath: 'assets/images/bg_green.png',
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: ColorsConstant.neutral300,
                                  blurRadius: 20,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: ColorsConstant.white,
                            ),
                            child: Column(
                              children: [
                                // Row untuk "Current grades" dan Dropdown filter bulan
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Current grades',
                                        style:
                                            TextStylesConstant.nunitoHeading6),
                                    DropdownButton<String>(
                                      dropdownColor: ColorsConstant.neutral100,
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
                                      items: months
                                          .map<DropdownMenuItem<String>>(
                                              (String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(month),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                // Daftar nilai (grade items)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredGradeItems.length,
                                  itemBuilder: (context, index) {
                                    final gradeItem = filteredGradeItems[index];

                                    // Fungsi untuk menghapus dua angka nol di belakang koma
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
                                      color: ColorsConstant.neutral100,
                                      shadowColor: ColorsConstant.neutral100,
                                      borderOnForeground: false,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: ColorsConstant
                                                          .primary300,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      formatGrade(gradeItem
                                                          .gradeFormatted),
                                                      style: TextStylesConstant
                                                          .nunitoHeading6
                                                          .copyWith(
                                                        color: ColorsConstant
                                                            .neutral100,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    gradeItem.itemName ??
                                                        'No name',
                                                    style: TextStylesConstant
                                                        .nunitoHeading6
                                                        .copyWith(
                                                      color: ColorsConstant
                                                          .neutral900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // Add this to remove the border
                                          tilePadding: EdgeInsets
                                              .zero, // Add this line to remove padding if needed
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(0),
                                                bottom: Radius.circular(
                                                    0)), // Remove border radius if needed
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Feedback: ${gradeItem.feedback ?? 'No feedback'}'),
                                                ],
                                              ),
                                            ),
                                          ],
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
                                  image:
                                      AssetImage("assets/images/Banner2.png"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
