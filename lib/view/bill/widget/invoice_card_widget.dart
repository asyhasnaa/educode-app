import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/profile/profile_conroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceCardWidget extends StatelessWidget {
  InvoiceCardWidget({
    super.key,
    required this.invoice,
  });

  final Map<String, dynamic> invoice;
  final ProfileController profileController = Get.put(ProfileController(
    apiProfileService: ApiProfileService(),
  ));

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(
      (invoice['dateInvoice'] as Timestamp).toDate(),
    );

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  'assets/images/logo_educode.png',
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice['name'] ?? 'Tidak ada nama',
                    style: TextStylesConstant.nunitoHeading16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileController.profile.value.fullname ?? '',
                    style: TextStylesConstant.nunitoCaptionBold.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: invoice['success'] ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invoice['success'] ? 'Lunas' : 'Belum Bayar',
                  style: TextStylesConstant.nunitoCaptionBold.copyWith(
                    color: invoice['success'] ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStylesConstant.nunitoCaptionBold.copyWith(
                        color: ColorsConstant.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Rp${invoice['total'] ?? 0}',
                        style: TextStylesConstant.nunitoHeading16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No',
                      style: TextStylesConstant.nunitoCaptionBold.copyWith(
                        color: ColorsConstant.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('#${invoice['invoiceNumber'] ?? '---'}',
                        style: TextStylesConstant.nunitoHeading16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Tagihan',
                      style: TextStylesConstant.nunitoCaptionBold.copyWith(
                        color: ColorsConstant.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(formattedDate,
                        style: TextStylesConstant.nunitoHeading16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
