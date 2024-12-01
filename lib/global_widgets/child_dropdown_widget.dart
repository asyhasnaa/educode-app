import 'package:dropdown_search/dropdown_search.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:educode/view_model/invoice/invoice_controller.dart';

class ChildDropdownWidget extends StatelessWidget {
  final Function(int childId)? onChildChanged;

  ChildDropdownWidget({this.onChildChanged, super.key});

  final LoginController loginController = Get.find();
  final CourseController courseController = Get.find();
  final ScheduleController scheduleController = Get.find();
  final InvoiceController invoiceController = Get.find();
  // final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (loginController.children.isEmpty) {
        return const Center(child: Text("No children found"));
      }

      int? selectedChildId = loginController.selectedUserId.value;

      // Validasi jika `selectedChildId` tidak ada dalam daftar anak
      if (!loginController.children
          .any((child) => child['childId'] == selectedChildId)) {
        selectedChildId = loginController.children.first['childId'];
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownSearch<String>(
            items: (String filter, LoadProps? loadProps) {
              return Future.value(
                loginController.children
                    .map((child) => child['name'] as String)
                    .toList(),
              );
            },
            selectedItem: loginController.children.firstWhere(
              (child) => child['childId'] == selectedChildId,
              orElse: () => loginController.children.first,
            )['name'] as String,
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              constraints:
                  const BoxConstraints(maxHeight: 400), // Tinggi maksimal popup
              menuProps: MenuProps(
                borderRadius: BorderRadius.circular(10), // Radius sudut popup
                backgroundColor:
                    ColorsConstant.neutral50, // Warna latar belakang popup
                elevation: 4, // Efek bayangan
              ),
              itemBuilder: (context, item, isSelected, isHighlighted) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsConstant.primary300
                        : isHighlighted
                            ? ColorsConstant.primary100
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: isSelected
                        ? TextStylesConstant.nunitoCaptionBold.copyWith(
                            color: Colors.white, // Warna teks jika dipilih
                            fontSize: 16, // Ukuran teks jika dipilih
                          )
                        : TextStylesConstant.nunitoButtonBold.copyWith(
                            color:
                                ColorsConstant.neutral800, // Warna teks default
                            fontSize: 14, // Ukuran teks default
                          ),
                  ),
                );
              },
            ),
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? "Select Child",
                style: TextStylesConstant.nunitoCaptionBold.copyWith(
                  color: ColorsConstant.neutral800,
                ),
              );
            },
            onChanged: (selectedName) {
              final selectedChild = loginController.children.firstWhere(
                (child) => child['name'] == selectedName,
                orElse: () => null,
              );

              if (selectedChild != null) {
                final childId = selectedChild['childId'] as int;

                // Perbarui `selectedUserId` di LoginController
                loginController.setSelectedUserId(childId);

                // Perbarui data terkait
                courseController.fetchUserCourse(childId);
                scheduleController.fetchScheduleForChild(selectedChild['name']);
                invoiceController.fetchInvoicesForChild(selectedChild['name']);

                // Panggil fungsi tambahan jika diperlukan
                if (onChildChanged != null) {
                  onChildChanged!(childId);
                }
              }
            },
            decoratorProps: DropDownDecoratorProps(
                baseStyle: TextStylesConstant.nunitoCaptionBold,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorsConstant.neutral200,
                    ),
                  ),
                ))),
      );
    });
  }
}
