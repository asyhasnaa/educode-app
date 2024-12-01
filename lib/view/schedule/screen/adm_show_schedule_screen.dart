import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/schedule/widget/adm_card_schedule_widget.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminShowSchedule extends StatelessWidget {
  AdminShowSchedule({super.key});

  final ScheduleController scheduleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender Bimbingan',
          style: TextStylesConstant.nunitoHeading24,
        ),
        backgroundColor: ColorsConstant.neutral100,
      ),
      backgroundColor: ColorsConstant.neutral100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: ColorsConstant.primary100,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() {
                return TableCalendar(
                  locale: 'id_ID',
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2025),
                  focusedDay: scheduleController.focusedDay.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(scheduleController.selectedDay.value, day),
                  calendarFormat: scheduleController.calendarFormat.value,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    markersMaxCount: 1,
                    markerDecoration: BoxDecoration(
                      color: ColorsConstant.primary300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    scheduleController.updateSelectedDay(selectedDay);
                  },
                  onFormatChanged: (format) {
                    scheduleController.updateCalendarFormat(format);
                  },
                  onPageChanged: (focusedDay) {
                    scheduleController.updateFocusedDay(focusedDay);
                  },
                );
              }),
            ),
            const SizedBox(height: 8.0),
            Text('Daftar Jadwal', style: TextStylesConstant.nunitoHeading18),
            const SizedBox(height: 8.0),
            Expanded(
              child: Obx(() {
                if (scheduleController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (scheduleController.schedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          IconsConstant.noSchedule,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'Tidak ada jadwal untuk hari ini.',
                          style: TextStylesConstant.nunitoCaption16,
                        ),
                      ],
                    ),
                  );
                }

                return AdminScheduleCardWidget();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
