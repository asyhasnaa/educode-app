import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/global_widgets/global_text_field_widget.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:educode/utils/constants/color_constant.dart';

class InputScheduleScreen extends StatefulWidget {
  const InputScheduleScreen({super.key});

  @override
  _InputScheduleScreenState createState() => _InputScheduleScreenState();
}

class _InputScheduleScreenState extends State<InputScheduleScreen> {
  final TextEditingController namaAnakController = TextEditingController();
  final TextEditingController namaCourseController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuMulaiController = TextEditingController();
  final TextEditingController waktuSelesaiController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  // Method untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tanggalController.text =
            "${picked.toLocal()}".split(' ')[0]; // Mengambil hanya tanggal
      });
    }
  }

  // Method untuk memilih waktu
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = "${picked.hour}:${picked.minute}";
      setState(() {
        if (isStartTime) {
          waktuMulaiController.text = formattedTime; // Simpan waktu mulai
        } else {
          waktuSelesaiController.text = formattedTime; // Simpan waktu selesai
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Jadwal',
          style: TextStylesConstant.nunitoHeading5,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              controller: namaAnakController,
              hintText: "Nama Anak",
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              obscureText: false,
            ),
            const SizedBox(height: 14),
            const Text(
              'Category',
              style: TextStyle(
                color: ColorsConstant.neutral800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GlobalTextFieldWidget(
              focusNode: FocusNode(),
              controller: namaCourseController,
              hintText: "Category",
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              obscureText: false,
            ),
            const SizedBox(height: 14),
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
            Text('Tanggal', style: TextStylesConstant.nunitoCaptionBold),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: GlobalTextFieldWidget(
                focusNode: FocusNode(),
                controller: tanggalController,
                hintText: "Pilih Tanggal",
                showSuffixIcon: true,
                keyboardType: TextInputType.none,
                obscureText: false,
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Waktu Mulai',
                        style: TextStylesConstant.nunitoCaptionBold),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: GlobalTextFieldWidget(
                        focusNode: FocusNode(),
                        controller: waktuMulaiController,
                        hintText: "Pilih Waktu Mulai",
                        showSuffixIcon: true,
                        keyboardType: TextInputType.none,
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Waktu Selesai',
                        style: TextStylesConstant.nunitoCaptionBold),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: GlobalTextFieldWidget(
                        focusNode: FocusNode(),
                        controller: waktuSelesaiController,
                        hintText: "Pilih Waktu Selesai",
                        showSuffixIcon: true,
                        keyboardType: TextInputType.none,
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SizedBox(height: 26),
            GlobalButtonWidget(
                text: 'Simpan Jadwal',
                onTap: () {
                  // Tambahkan logika penyimpanan jadwal di sini
                }),
          ],
        ),
      ),
    );
  }
}
