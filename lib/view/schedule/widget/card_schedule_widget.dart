import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardScheduleWidget extends StatelessWidget {
  const CardScheduleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                ColorsConstant.primary300,
                ColorsConstant.primary300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coding Construct',
              style: TextStylesConstant.nunitoButtonBold
                  .copyWith(color: ColorsConstant.white),
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  SvgPicture.asset(IconsConstant.person),
                  const SizedBox(width: 10),
                  Text('Gerard',
                      style: TextStylesConstant.nunitoCaption
                          .copyWith(color: ColorsConstant.white))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  SvgPicture.asset(IconsConstant.calender),
                  const SizedBox(width: 10),
                  Text(
                    'Senin, 3 Agustus 2024',
                    style: TextStylesConstant.nunitoCaption
                        .copyWith(color: ColorsConstant.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  SvgPicture.asset(IconsConstant.time),
                  const SizedBox(width: 10),
                  Text(
                    '16.30 - 18.30 WIB',
                    style: TextStylesConstant.nunitoCaption
                        .copyWith(color: ColorsConstant.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  SvgPicture.asset(IconsConstant.location),
                  const SizedBox(width: 10),
                  Text(
                    'Perumahan Permata Hijau',
                    style: TextStylesConstant.nunitoCaption
                        .copyWith(color: ColorsConstant.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
