import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailTagihanScreen extends StatelessWidget {
  final String parent;
  final String emailParent;
  final Map<String, dynamic> invoice;

  const DetailTagihanScreen(
      {super.key,
      required this.invoice,
      required this.parent,
      required this.emailParent});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController(
      apiProfileService: ApiProfileService(),
    ));

    profileController.fetchUserProfile();
    // Format tanggal invoice dari firebase
    String formattedDate = DateFormat('dd MMM yyyy').format(
      (invoice['dateInvoice'] as Timestamp).toDate(),
    );

    return Scaffold(
      backgroundColor: ColorsConstant.neutral100,
      appBar: AppBar(
        title: Text(
          'Detail Tagihan',
          style: TextStylesConstant.nunitoHeading20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: ColorsConstant.neutral100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice #${invoice['invoiceNumber']}',
              style: TextStylesConstant.nunitoHeading24,
            ),
            const SizedBox(height: 10),
            // Billing Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dari',
                              style: TextStylesConstant.nunitoExtraBoldTitle),
                          const SizedBox(height: 8),
                          Text(
                            'Education Code Purwokerto',
                            style: TextStylesConstant.nunitoCaption16.copyWith(
                              color: ColorsConstant.neutral600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: invoice['success']
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          invoice['success'] ? 'Lunas' : 'Belum Bayar',
                          style: TextStylesConstant.nunitoCaptionBold.copyWith(
                            color:
                                invoice['success'] ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parent,
                            style: TextStylesConstant.nunitoHeading20
                                .copyWith(color: ColorsConstant.black),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailParent,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nama Anak',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(invoice['name']),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Tanggal Tagihan',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(formattedDate),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Invoice Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Item',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ..._buildInvoiceDetails(invoice['details'] ?? []),
                  const Divider(height: 24, thickness: 1),
                  Column(
                    children: [
                      _buildTotalRow(
                        label: 'Total',
                        value: invoice['total'] ?? 'Rp0',
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInvoiceDetails(List<dynamic> details) {
    if (details.isEmpty) {
      return [
        const Text(
          'Tidak ada item pada tagihan ini.',
          style: TextStyle(color: Colors.grey),
        ),
      ];
    }

    return details.map((detail) {
      String date = DateFormat('dd MMM yyyy').format(
        (detail['date'] as Timestamp).toDate(),
      );
      return _buildInvoiceItemRow(
        course: detail['course'] ?? '---',
        date: date,
        price: 'Rp${detail['price'] ?? 0}',
      );
    }).toList();
  }

  Widget _buildInvoiceItemRow({
    required String course,
    required String date,
    required String price,
  }) {
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
      ),
      columnWidths: const {
        0: FixedColumnWidth(150), // Width for the course column
        1: FixedColumnWidth(100), // Width for the date column
        2: FixedColumnWidth(100), // Width for the price column
      },
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                course,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                date,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                price,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_green.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14),
          ),
          Text(
            value,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
                color: isBold ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
