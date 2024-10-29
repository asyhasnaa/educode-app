import 'package:educode/services/api_course.dart';
import 'package:educode/view/home/widget/course_card_widget.dart';
import 'package:educode/view_model/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCourseScreen extends StatefulWidget {
  const ListCourseScreen({super.key});

  @override
  State<ListCourseScreen> createState() => _ListCourseScreenState();
}

class _ListCourseScreenState extends State<ListCourseScreen> {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Course'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: CourseCardWidget(
          courseController: courseController,
        )),
      )),
    );
  }
}
