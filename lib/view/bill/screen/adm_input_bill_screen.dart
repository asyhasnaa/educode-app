import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/global_widgets/global_text_field_widget.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:educode/utils/constants/color_constant.dart';

class InputBillScreen extends StatefulWidget {
  const InputBillScreen({super.key});

  @override
  _InputBillScreenState createState() => _InputBillScreenState();
}

class _InputBillScreenState extends State<InputBillScreen> {
  final TextEditingController namaAnakController = TextEditingController();
  final TextEditingController namaCourseController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tagihan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Tagihan',
              style: TextStyle(
                color: ColorsConstant.neutral800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: namaAnakController,
              hintText: "Tanggal Tagihan",
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              obscureText: false,
            ),
            const SizedBox(height: 14),
            const Text(
              'Nama Anak',
              style: TextStyle(
                color: ColorsConstant.neutral800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: namaCourseController,
              hintText: "Nama Anak",
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              obscureText: false,
            ),
            const SizedBox(
              height: 14,
            ),
            Text('Nama Course', style: TextStylesConstant.nunitoCaptionBold),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: namaCourseController,
              hintText: "Nama Course",
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              obscureText: false,
            ),
            const SizedBox(height: 14),
            Text('Nama Course', style: TextStylesConstant.nunitoCaptionBold),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: tanggalController,
              hintText: "Nama Course",
              showSuffixIcon: false,
              keyboardType: TextInputType.datetime,
              obscureText: false,
            ),
            const SizedBox(height: 14),
            Text('Nama Course', style: TextStylesConstant.nunitoCaptionBold),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: tanggalController,
              hintText: "Nama Course",
              showSuffixIcon: false,
              keyboardType: TextInputType.datetime,
              obscureText: false,
            ),
            const SizedBox(height: 26),
            GlobalButtonWidget(text: 'Simpan Tagihan', onTap: () {})
          ],
        ),
      ),
    );
  }
}
