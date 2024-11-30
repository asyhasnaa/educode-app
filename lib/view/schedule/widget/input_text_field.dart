import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const InputTextFieldWidget(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStylesConstant.nunitoCaptioReguler),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
                border: Border.all(color: ColorsConstant.neutral200, width: 1)),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                autofocus: false,
                controller: controller,
                style: TextStylesConstant.nunitoButtonSemibold,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStylesConstant.nunitoButtonSemibold,
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorsConstant.primary300, width: 1)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 16)),
              ))
            ]),
          )
        ],
      ),
    );
  }
}
