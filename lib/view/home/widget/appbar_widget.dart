import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Selamat Datang, \nKartika Dewi",
              style: TextStylesConstant.nunitoHeading18
                  .copyWith(color: ColorsConstant.black),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: Colors.white,
                    fixedSize: const Size(55, 55)),
                icon: const Icon(Icons.notification_add_outlined)),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(),
      ],
    );
  }
}
