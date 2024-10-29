import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/screen/adm_input_bill_screen.dart';
import 'package:educode/view/bill/widget/bill_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBillScreen extends StatefulWidget {
  const AdminBillScreen({super.key});

  @override
  State<AdminBillScreen> createState() => _AdminBillScreenState();
}

class _AdminBillScreenState extends State<AdminBillScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Contoh data tagihan (dummy)
  final List<Map<String, dynamic>> bills = [
    {
      'bulan': 'Januari',
      'namaAnak': 'Andi',
      'jumlah': 500000.00,
      'status': 'Belum Lunas',
    },
    {
      'bulan': 'Februari',
      'namaAnak': 'Budi',
      'jumlah': 450000.00,
      'status': 'Lunas',
    },
    {
      'bulan': 'Maret',
      'namaAnak': 'Citra',
      'jumlah': 600000.00,
      'status': 'Belum Lunas',
    },
    {
      'bulan': 'April',
      'namaAnak': 'Dewi',
      'jumlah': 550000.00,
      'status': 'Lunas',
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
      appBar: AppBar(
        title: Text(
          'Tagihan',
          style: TextStylesConstant.nunitoHeading5,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.0,
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      tabs: List.generate(2, (index) {
                        return _buildTabItem(index);
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab Belum Bayar
                  ListView.builder(
                    itemCount: bills
                        .where((bill) => bill['status'] == 'Belum Lunas')
                        .length,
                    itemBuilder: (context, index) {
                      final bill = bills
                          .where((bill) => bill['status'] == 'Belum Lunas')
                          .toList()[index];
                      return BillCardWidget(
                        bulan: bill['bulan'],
                        namaAnak: bill['namaAnak'],
                        jumlah: bill['jumlah'],
                        status: bill['status'],
                        onTap: () {
                          // Aksi ketika menekan detail tagihan
                        },
                      );
                    },
                  ),
                  // Tab Riwayat
                  ListView.builder(
                    itemCount:
                        bills.where((bill) => bill['status'] == 'Lunas').length,
                    itemBuilder: (context, index) {
                      final bill = bills
                          .where((bill) => bill['status'] == 'Lunas')
                          .toList()[index];
                      return BillCardWidget(
                        bulan: bill['bulan'],
                        namaAnak: bill['namaAnak'],
                        jumlah: bill['jumlah'],
                        status: bill['status'],
                        onTap: () {
                          // Aksi ketika menekan detail tagihan
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.secondary300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Get.to(() => InputBillScreen());
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
        setState(() {}); // Update state untuk perubahan warna
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 120,
        decoration: BoxDecoration(
          color: isSelected ? ColorsConstant.primary300 : Colors.white,
          border: Border.all(
            color: ColorsConstant.primary300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorsConstant.primary300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
