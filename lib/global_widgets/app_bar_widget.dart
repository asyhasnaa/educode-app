// SliverChildAppBarWidget
import 'package:dropdown_search/dropdown_search.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SliverChildAppBarWidget extends StatelessWidget {
  final String title;
  final String description;
  final String backgroundImagePath;
  final bool showBackButton;
  final Function(String) onChildSelected;

  SliverChildAppBarWidget({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundImagePath,
    required this.onChildSelected,
    this.showBackButton = true,
  });

  final loginController = Get.find<LoginController>();
  final courseController = Get.find<CourseController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      automaticallyImplyLeading: false,
      pinned: false,
      floating: true,
      elevation: 0,
      backgroundColor: ColorsConstant.neutral100,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var top = constraints.biggest.height;
            return FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: top > 120 ? 16 : 10,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: top > 120
                      ? Colors.transparent
                      : ColorsConstant.primary300,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStylesConstant.nunitoHeading24.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Obx(() {
                              final children = loginController.children;

                              if (children.isEmpty) {
                                return const Center(
                                    child:
                                        Text("Tidak ada data anak tersedia"));
                              }

                              return DropdownSearch<String>(
                                items: (String filter, LoadProps? loadProps) {
                                  return Future.value(
                                    loginController.children
                                        .map((child) => child['name'] as String)
                                        .toList(),
                                  );
                                },
                                selectedItem: children.first['name'] as String,
                                onChanged: (selectedName) {
                                  print("Selected name: $selectedName");
                                  if (selectedName != null) {
                                    final selectedChild = children.firstWhere(
                                      (child) => child['name'] == selectedName,
                                      orElse: () => null,
                                    );

                                    if (selectedChild != null) {
                                      final childId =
                                          selectedChild['childId'] as int;

                                      print("Selected childId: $childId");

                                      courseController
                                          .updateSelectedUserId(childId);

                                      onChildSelected(selectedName);
                                    }
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showBackButton)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            IconsConstant.arrowLeft,
                            height: 24,
                            width: 24,
                            // ignore: deprecated_member_use
                            color: ColorsConstant.white,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
