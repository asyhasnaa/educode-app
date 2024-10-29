import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/screen/detail_bill_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BillCardWidget extends StatelessWidget {
  final String bulan;
  final String namaAnak;
  final double jumlah;
  final String status;
  final VoidCallback onTap;

  const BillCardWidget({
    super.key,
    required this.bulan,
    required this.namaAnak,
    required this.jumlah,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsConstant.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Date, name, status, and price
            Column(
              children: [
                const Text(
                  '5 Okt, 20:26', // Date in the top-left corner
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/tagihan.svg', // Path to your tagihan.png image
                  width: 50,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    namaAnak,
                    style: TextStylesConstant.nunitoHeading6,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Coding Construct', // Custom text (or you can bind it)
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side: Image, price, and button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp222.000',
                  style: TextStylesConstant.nunitoHeading6,
                ),
                const SizedBox(height: 10),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const DetailTagihanScreen());
                    }, // Navigate to the detail screen
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: ColorsConstant.neutral300,
                    ),
                    child: Text('Detail',
                        style: TextStylesConstant.nunitoCaptionBold.copyWith(
                          color: ColorsConstant.black,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
