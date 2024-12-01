import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleCardWidget extends StatelessWidget {
  final ScheduleController scheduleController = Get.find();
  final String childName;
  ScheduleCardWidget({
    super.key,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (scheduleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (scheduleController.schedules.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: ColorsConstant.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  IconsConstant.noSchedule,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Tidak ada jadwal untuk hari ini.',
                  style: TextStylesConstant.nunitoCaption16,
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scheduleController.schedules.length,
        itemBuilder: (context, index) {
          final schedule = scheduleController.schedules[index];
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: ColorsConstant.white,
              boxShadow: [
                BoxShadow(color: ColorsConstant.neutral300, blurRadius: 20),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${schedule['name']}, ${schedule['category']} ",
                  style: TextStylesConstant.nunitoButtonBold,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SvgPicture.asset(IconsConstant.calender),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(
                        (schedule['date'] as Timestamp).toDate(),
                      ),
                      style: TextStylesConstant.nunitoButtonBold,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SvgPicture.asset(IconsConstant.time),
                    const SizedBox(width: 10),
                    Text(
                      "${schedule['timeStart']} - ${schedule['timeEnd']} WIB",
                      style: TextStylesConstant.nunitoButtonBold,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SvgPicture.asset(IconsConstant.location),
                    const SizedBox(width: 10),
                    Text(
                      schedule['address'],
                      style: TextStylesConstant.nunitoButtonBold,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
