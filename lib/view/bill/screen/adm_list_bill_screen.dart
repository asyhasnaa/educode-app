import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/screen/detail_bill_screen.dart';
import 'package:educode/view/bill/screen/generate_invoice.dart';
import 'package:educode/view/bill/widget/invoice_card_widget.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminInvoiceListPage extends StatefulWidget {
  const AdminInvoiceListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminInvoiceListPageState createState() => _AdminInvoiceListPageState();
}

class _AdminInvoiceListPageState extends State<AdminInvoiceListPage> {
  final invoiceController = Get.put(InvoiceController());
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch all invoices saat halaman pertama kali dibuka
    invoiceController.fetchAllInvoices(); // Kosongkan untuk semua anak
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Invoice',
          style: TextStylesConstant.nunitoHeading24,
        ),
        backgroundColor: ColorsConstant.neutral100,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ColorsConstant.neutral100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final summary = invoiceController.getInvoiceSummary();
              return _buildSummaryWidget(summary);
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari Invoice...',
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        // Filter invoices berdasarkan query
                        invoiceController.searchInvoices(query);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logika filter tambahan jika diperlukan
                    },
                    child: const Icon(
                      Icons.tune, // Ikon untuk filter
                      color: ColorsConstant.secondary300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Daftar Tagihan ',
                  style: TextStylesConstant.nunitoHeading16,
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('Semua'),
                    ),
                    DropdownMenuItem(
                      value: 'paid',
                      child: Text('Lunas'),
                    ),
                    DropdownMenuItem(
                      value: 'unpaid',
                      child: Text('Belum Bayar'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedFilter = value!;
                      invoiceController.filterAdminInvoices(selectedFilter);
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorsConstant.neutral600,
                  ),
                  underline: Container(),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (invoiceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (invoiceController.filteredAdminInvoices.isEmpty) {
                  return const Center(child: Text('Tidak ada tagihan.'));
                }
                return ListView.builder(
                  itemCount: invoiceController.filteredAdminInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice =
                        invoiceController.filteredAdminInvoices[index];
                    return GestureDetector(
                      child: InvoiceCardWidget(
                        invoice: invoice,
                      ),
                      onTap: () {
                        Get.to(() => DetailTagihanScreen(
                              invoice: invoice,
                              parent: invoice['username'],
                              emailParent: 'Nama Orangtua',
                            ));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.secondary300,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GenerateInvoiceScreen(),
            ),
          );
        },
        tooltip: 'Tambah Invoice',
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildSummaryWidget(Map<String, int> summary) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_green.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryColumn('Lunas', summary['paid']!, Colors.white),
          _buildSummaryColumn('Belum Bayar', summary['unpaid']!, Colors.white),
          _buildSummaryColumn('Total', summary['total']!, Colors.white),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String label, int count, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStylesConstant.nunitoHeading24.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStylesConstant.nunitoHeading16.copyWith(color: textColor),
        ),
      ],
    );
  }
}
