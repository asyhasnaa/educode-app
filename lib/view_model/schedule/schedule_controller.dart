import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleController extends GetxController {
  //List Variable untuk menyimpan data jadwal
  var schedulesChild = <Map<String, dynamic>>[].obs;
  var schedules = <Map<String, dynamic>>[].obs;
  var calendarFormat = CalendarFormat.month.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var isLoading = false.obs;

  var selectedCategory = Rxn<String>();
  var selectedCourse = Rxn<String>();
  var addressController = TextEditingController();
  var priceController = TextEditingController();
  var dateController = TextEditingController();
  var timeStartController = TextEditingController();
  var timeEndController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchScheduleForAdmin(
        DateTime.now()); // Ambil jadwal untuk hari ini langsung
  }

  //Metode untuk mendapatkan jadwal sesuai nama anak
  Future<void> fetchScheduleForChild(String childName) async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      final todayStart =
          Timestamp.fromDate(DateTime(today.year, today.month, today.day));
      final todayEnd = Timestamp.fromDate(
          DateTime(today.year, today.month, today.day, 23, 59, 59));

      final snapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('name', isEqualTo: childName)
          .where('date', isGreaterThanOrEqualTo: todayStart)
          .where('date', isLessThanOrEqualTo: todayEnd)
          .get();

      if (snapshot.docs.isNotEmpty) {
        if (kDebugMode) {
          print("Jadwal ditemukan untuk hari ini.");
        }
        schedules.value = snapshot.docs.map((doc) => doc.data()).toList();
      } else {
        if (kDebugMode) {
          print("Tidak ada jadwal untuk hari ini.");
        }
        schedules.clear();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching schedule: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  //Metode untuk mendapatkan jadwal by tanggal untuk halaman admin
  void fetchScheduleForAdmin(DateTime selectedDate) {
    isLoading.value = true;
    final startOfDay = Timestamp.fromDate(
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
    );
    final endOfDay = Timestamp.fromDate(
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1),
    );

    FirebaseFirestore.instance
        .collection('schedules')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .snapshots()
        .listen((snapshot) {
      schedules.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      isLoading.value = false;
    });
  }

  void updateCalendarFormat(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void updateFocusedDay(DateTime focusedDayValue) {
    focusedDay.value = focusedDayValue;
  }

  void updateSelectedDay(DateTime selectedDayValue) {
    selectedDay.value = selectedDayValue;
    fetchScheduleForAdmin(selectedDayValue);
  }

  //Metode untuk menyimpan jadwal ke firebase
  Future<void> saveSchedule(Map<String, dynamic> scheduleData,
      {DateTime? selectedDate}) async {
    try {
      selectedDate ??= DateTime.now();

      if (scheduleData['id'] == null) {
        await FirebaseFirestore.instance
            .collection('schedules')
            .add(scheduleData);
      } else {
        await FirebaseFirestore.instance
            .collection('schedules')
            .doc(scheduleData['id'])
            .set(scheduleData);
      }

      Get.snackbar('Sukses', 'Jadwal berhasil ditambahkan');

      // Refresh jadwal berdasarkan tanggal yang diberikan
      fetchScheduleForAdmin(selectedDate);
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menyimpan jadwal: $e");
    }
  }

  // Metode untuk memperbarui jadwal yang ada
  Future<void> updateSchedule(
      String id, Map<String, dynamic> scheduleData) async {
    try {
      if (id.isEmpty || scheduleData.isEmpty) {
        throw Exception('ID atau data jadwal tidak boleh kosong.');
      }

      // Update dokumen berdasarkan ID
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(id)
          .update(scheduleData);

      Get.snackbar('Sukses', 'Jadwal berhasil diperbarui');

      // Refresh daftar jadwal berdasarkan tanggal yang diperbarui
      if (scheduleData.containsKey('date')) {
        final updatedDate = (scheduleData['date'] as Timestamp).toDate();
        fetchScheduleForAdmin(updatedDate);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui jadwal: $e');
    }
  }

// Metode untuk menghapus jadwal
  Future<void> deleteSchedule(String id, DateTime selectedDate) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID jadwal tidak boleh kosong.');
      }

      // Hapus dokumen berdasarkan ID
      await FirebaseFirestore.instance.collection('schedules').doc(id).delete();

      Get.snackbar('Sukses', 'Jadwal berhasil dihapus');

      // Refresh daftar jadwal berdasarkan tanggal yang dipilih
      fetchScheduleForAdmin(selectedDate);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus jadwal: $e');
    }
  }
}
