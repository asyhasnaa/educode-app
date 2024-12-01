import 'package:educode/global_widgets/child_dropdown_widget.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/screen/detail_bill_screen.dart';
import 'package:educode/view/bill/widget/invoice_card_widget.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage>
    with SingleTickerProviderStateMixin {
  final invoiceController = Get.put(InvoiceController());
  final LoginController loginController = Get.find();
  final CourseController courseController = Get.find();
  final ProfileController profileController = Get.put(ProfileController(
    apiProfileService: ApiProfileService(),
  ));
  // final HomeController homeController = Get.put(HomeController());

  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();

    // Fetch invoice data for the initially selected child
    if (loginController.children.isNotEmpty) {
      final initialChildName = loginController.children.firstWhere(
          (child) => child['childId'] == loginController.selectedUserId.value,
          orElse: () => {})['name'];
      if (initialChildName != null) {
        invoiceController.fetchInvoicesForChild(initialChildName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tagihan',
          style: TextStylesConstant.nunitoHeading20,
        ),
        centerTitle: true,
        backgroundColor: ColorsConstant.neutral100,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ColorsConstant.neutral100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                // Cek apakah data anak sudah tersedia
                if (loginController.children.isEmpty) {
                  return const Center(child: Text("No children found"));
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ChildDropdownWidget(
                      onChildChanged: (childId) {
                        // Ambil nama anak berdasarkan `childId` yang dipilih
                        final selectedChild = loginController.children
                            .firstWhere((child) => child['childId'] == childId,
                                orElse: () => {});
                        final childName = selectedChild['name'] ?? '';

                        // Perbarui data tagihan berdasarkan nama anak
                        invoiceController.fetchInvoicesForChild(childName);
                      },
                    ),
                  );
                }
              }),
              const SizedBox(height: 16),
              Text(
                'Ringkasan Tagihan',
                style: TextStylesConstant.nunitoHeading16,
              ),
              const SizedBox(height: 10),
              Obx(() {
                final summary = invoiceController.getInvoiceSummary();

                return Container(
                  height: 100,
                  width: double.infinity,
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
                      _buildSummaryColumn(
                          'Lunas', summary['paid']!, Colors.white),
                      _buildSummaryColumn(
                          'Tagihan', summary['unpaid']!, Colors.white),
                      _buildSummaryColumn(
                          'Total', summary['total']!, Colors.white),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Daftar Tagihan',
                    style: TextStylesConstant.nunitoHeading16,
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text(
                          'Semua',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'paid',
                        child: Text(
                          'Lunas',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'unpaid',
                        child: Text(
                          'Belum Bayar',
                        ),
                      )
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        selectedFilter = value!;
                        invoiceController.filterInvoices(selectedFilter);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorsConstant.neutral600,
                    ),
                    alignment: Alignment.centerRight,
                    style: TextStylesConstant.nunitoButtonSemibold
                        .copyWith(color: ColorsConstant.neutral600),
                    underline: Container(),
                  )
                ],
              ),
              Obx(() {
                if (invoiceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (invoiceController.filteredInvoices.isEmpty) {
                  return const Center(child: Text("No invoices found."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invoiceController.filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = invoiceController.filteredInvoices[index];
                    return GestureDetector(
                      child: InvoiceCardWidget(
                        invoice: invoice,
                      ),
                      onTap: () {
                        Get.to(() => DetailTagihanScreen(
                              invoice: invoice,
                              parent:
                                  "${profileController.profile.value.fullname}",
                              emailParent:
                                  "${profileController.profile.value.email}",
                            ));
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String label, int count, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStylesConstant.nunitoHeading24.copyWith(
            color: ColorsConstant.neutral50,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStylesConstant.nunitoHeading16.copyWith(
            color: ColorsConstant.neutral50,
          ),
        ),
      ],
    );
  }
}
