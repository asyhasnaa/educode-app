import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleCardWidget extends StatelessWidget {
  const ScheduleCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 157,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorsConstant.white,
        boxShadow: [
          BoxShadow(color: ColorsConstant.neutral300, blurRadius: 20),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(
            'Coding Construct',
            style: TextStylesConstant.nunitoButtonBold.copyWith(),
            textAlign: TextAlign.start,
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                SvgPicture.asset(IconsConstant.calender),
                const SizedBox(width: 10),
                Text('Senin, 3 Agustus 2024',
                    style: TextStylesConstant.nunitoButtonBold)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                SvgPicture.asset(IconsConstant.time),
                const SizedBox(width: 10),
                Text('16.30 - 18.30 WIB',
                    style: TextStylesConstant.nunitoButtonBold)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                SvgPicture.asset(IconsConstant.location),
                const SizedBox(width: 10),
                Text('Perumahan Permata Hijau',
                    style: TextStylesConstant.nunitoButtonBold)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
