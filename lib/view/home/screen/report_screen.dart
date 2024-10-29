import 'package:educode/view_model/course_controller.dart';
import 'package:educode/view_model/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseController courseController = Get.find<CourseController>();

  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: Obx(() {
        if (courseController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (courseController.course.isEmpty) {
          return const Center(child: Text('No courses available'));
        }
        return ListView.builder(
          itemCount: courseController.course.length,
          itemBuilder: (context, index) {
            final course = courseController.course[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                // leading: Image.network(
                //   course.courseimage,
                //   width: 50,
                //   height: 50,
                //   fit: BoxFit.cover,
                // ),
                title: Text(course.displayname),
                subtitle:
                    Text('Progress: ${course.progress.toStringAsFixed(2)}%'),
                onTap: () {
                  // Aksi saat kursus di-tap, misalnya navigasi ke detail course
                  Get.snackbar(
                      'Course Selected', 'You selected ${course.displayname}');
                },
              ),
            );
          },
        );
      }),
    );
  }
}
