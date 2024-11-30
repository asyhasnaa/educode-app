import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SliverAppBarWidget extends StatelessWidget {
  final String title;
  final String description;
  final String courseName;
  final int gradeLevel;
  final String backgroundImagePath;
  final bool showBackButton;

  const SliverAppBarWidget({
    super.key,
    required this.title,
    required this.description,
    required this.courseName,
    required this.gradeLevel,
    required this.backgroundImagePath,
    this.showBackButton = true, // Default to showing the back button
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      automaticallyImplyLeading: false, // Prevent default back button
      pinned: true,
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
                vertical: top > 120 ? 16 : 10, // Adjusts padding on scroll
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
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(81, 245, 245, 245),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsConstant.primary300,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.school,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 3,
                                      ),
                                      Text(
                                        "Category $gradeLevel",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                              borderRadius: BorderRadius.circular(8)),
                          child: SvgPicture.asset(
                            IconsConstant.arrowLeft,
                            height: 24,
                            width: 24,
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
