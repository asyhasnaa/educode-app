import 'package:educode/global_widgets/app_bar_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/view/bill/screen/detail_bill_screen.dart';
import 'package:educode/view/bill/widget/bill_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagihanPembayaranScreen extends StatefulWidget {
  const TagihanPembayaranScreen({super.key});

  @override
  _TagihanPembayaranScreenState createState() =>
      _TagihanPembayaranScreenState();
}

class _TagihanPembayaranScreenState extends State<TagihanPembayaranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _belumBayarList = [
    {
      'bulan': 'Januari',
      'namaAnak': 'Gerard',
      'jumlah': 3000000,
      'status': 'Belum bayar',
    },
    {
      'bulan': 'Februari',
      'namaAnak': 'Alex',
      'jumlah': 2500000,
      'status': 'Belum bayar',
    },
  ];

  final List<Map<String, dynamic>> _riwayatList = [
    {
      'bulan': 'Desember',
      'namaAnak': 'Gerard',
      'jumlah': 3000000,
      'status': 'Sudah dibayar',
    },
    {
      'bulan': 'November',
      'namaAnak': 'Alex',
      'jumlah': 2500000,
      'status': 'Sudah dibayar',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.white,
      body: CustomScrollView(
        slivers: [
          const AppBarWidget(
            backgroundImagePath: "assets/images/bg_purple.png",
            title: 'Tagihan Pembayaran',
            description: 'Tagihan Pembayaran',
            courseName: 'Dewi Kartika Sari',
            gradeLevel: 1,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTabItem(0),
                      const SizedBox(width: 16),
                      _buildTabItem(1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BillCardWidget(
                      bulan: "Januari",
                      namaAnak: "Gerard",
                      jumlah: 300.000,
                      status: "Lunas",
                      onTap: () {})
                ],
              ),
            )
          ]))
        ],
      ),
    );
  }

  // Membuat tampilan item tab dengan kondisi aktif dan tidak aktif
  Widget _buildTabItem(int index) {
    bool isSelected = _tabController.index == index;
    String label;
    switch (index) {
      case 0:
        label = 'Belum Bayar';
        break;
      case 1:
        label = 'Riwayat';
        break;
      default:
        label = 'Tagihan';
    }

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? ColorsConstant.primary300 : ColorsConstant.white,
          border: Border.all(
            color: ColorsConstant.primary300,
          ),
          borderRadius: BorderRadius.circular(20),
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

  // Fungsi untuk membangun list "Belum Bayar"
  Widget _buildBelumBayarList() {
    return ListView.builder(
      itemCount: _belumBayarList.length,
      itemBuilder: (context, index) {
        final item = _belumBayarList[index];
        return BillCardWidget(
          bulan: item['bulan'],
          namaAnak: item['namaAnak'],
          jumlah: item['jumlah'],
          status: item['status'],
          onTap: () {
            Get.to(() => const DetailTagihanScreen());
          },
        );
      },
    );
  }

  // Fungsi untuk membangun list "Riwayat"
  Widget _buildRiwayatList() {
    return ListView.builder(
      itemCount: _riwayatList.length,
      itemBuilder: (context, index) {
        final item = _riwayatList[index];
        return BillCardWidget(
          bulan: item['bulan'],
          namaAnak: item['namaAnak'],
          jumlah: item['jumlah'],
          status: item['status'],
          onTap: () {
            Get.to(() => const DetailTagihanScreen());
          },
        );
      },
    );
  }
}
