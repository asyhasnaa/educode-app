import 'package:educode/global_widgets/app_bar_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/home/widget/schedule_card_widget.dart';
import 'package:educode/view/schedule/widget/adm_card_schedule_widget.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminShowSchedule extends StatefulWidget {
  const AdminShowSchedule({super.key});

  @override
  _AdminShowScheduleState createState() => _AdminShowScheduleState();
}

class _AdminShowScheduleState extends State<AdminShowSchedule> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final ScheduleController _scheduleController = Get.find();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _scheduleController.fetchScheduleForAdmin(DateTime.now());
  }

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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ColorsConstant.primary100,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime(2020),
                lastDay: DateTime(2025),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
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
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  // Move this logic into the controller
                  _scheduleController.fetchScheduleForAdmin(selectedDay);
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Daftar Jadwal', style: TextStylesConstant.nunitoHeading18),
            SizedBox(height: 8.0),
            Expanded(
              child: Obx(() {
                if (_scheduleController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_scheduleController.schedules.isEmpty) {
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
