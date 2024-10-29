import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/schedule/screen/adm_input_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController; // Deklarasi late

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController di initState
    _tabController = TabController(length: 7, vsync: this); // 7 hari
  }

  @override
  void dispose() {
    _tabController.dispose(); // Pastikan untuk dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Bimbingan',
          style: TextStylesConstant.nunitoHeading5,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Menggunakan Wrap untuk membungkus TabBar sehingga bisa tampil dalam dua baris
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.0, // Jarak antar tab
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  // Menghilangkan indicator bawaan
                  dividerColor: Colors.transparent,
                  indicator: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  tabs: List.generate(7, (index) {
                    return _buildTabItem(index);
                  }),
                ),
              ],
            ),
          ),
          // Isi dari TabBarView untuk semua hari
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Jadwal Senin')),
                Center(child: Text('Jadwal Selasa')),
                Center(child: Text('Jadwal Rabu')),
                Center(child: Text('Jadwal Kamis')),
                Center(child: Text('Jadwal Jumat')),
                Center(child: Text('Jadwal Sabtu')),
                Center(child: Text('Jadwal Minggu')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.secondary300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Get.to(() => InputScheduleScreen());
        },
        child: const Icon(
          Icons.add,
          color: ColorsConstant.white,
          size: 30,
        ),
      ),
    );
  }

  // Membuat tampilan item tab dengan kondisi aktif dan tidak aktif
  Widget _buildTabItem(int index) {
    bool isSelected = _tabController.index == index;
    String label;
    switch (index) {
      case 0:
        label = 'Senin';
        break;
      case 1:
        label = 'Selasa';
        break;
      case 2:
        label = 'Rabu';
        break;
      case 3:
        label = 'Kamis';
        break;
      case 4:
        label = 'Jumat';
        break;
      case 5:
        label = 'Sabtu';
        break;
      case 6:
        label = 'Minggu';
        break;
      default:
        label = 'Hari';
    }

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {}); // Update state untuk perubahan warna
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? ColorsConstant.primary300 : Colors.white,
          border: Border.all(
            color: ColorsConstant.primary300, // Warna border biru
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : ColorsConstant.primary300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
