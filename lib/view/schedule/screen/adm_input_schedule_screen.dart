import 'package:dropdown_search/dropdown_search.dart';
import 'package:educode/services/api_course.dart';
import 'package:educode/view_model/course/course_controller.dart';
import 'package:educode/view_model/home/get_children.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/schedule/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/global_widgets/global_text_field_widget.dart';

class InputScheduleScreen extends StatefulWidget {
  final Map<String, dynamic>? scheduleData;
  final bool isEditMode;
  const InputScheduleScreen(
      {super.key, this.scheduleData, this.isEditMode = false});

  @override
  _InputScheduleScreenState createState() => _InputScheduleScreenState();
}

class _InputScheduleScreenState extends State<InputScheduleScreen> {
  final CourseController courseController =
      Get.put(CourseController(apiCourseService: ApiCourseService()));
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeStartController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? selectedCategory;
  String? selectedCourse;
  String? selectedColor;
  String? selectedChildName;
  String? selectedParentUsername;
  final List<String> categories = ['Privat', 'Group'];
  final List<String> colorOptions = ['Green', 'Purple'];
  List<Map<String, String>> childrenWithParents = [];
  bool isDropdownLoading = false;
  late String scheduleId;

  Future<void> fetchChildrenNames() async {
    setState(() {
      isDropdownLoading = true;
    });

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, String>> fetchedChildren = [];
      for (var userDoc in usersSnapshot.docs) {
        print('Processing doc: ${userDoc.data()}');
        String parentUsername = userDoc['username'];
        print('Parent Username: $parentUsername');
        List<dynamic> children = userDoc['children'];
        for (var child in children) {
          if (child is Map<String, dynamic>) {
            final childName = child['name']?.toString() ?? '';
            if (childName.isNotEmpty) {
              fetchedChildren.add({
                'name': childName,
                'username': parentUsername,
              });
            }
          }
        }
      }

      setState(() {
        childrenWithParents = fetchedChildren;
      });
    } catch (e) {
      print("Error fetching children names: $e");
    }

    setState(() {
      isDropdownLoading = false;
    });
  }

  // Date selection method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Time selection method
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final String formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      setState(() {
        if (isStartTime) {
          timeStartController.text = formattedTime;
        } else {
          timeEndController.text = formattedTime;
        }
      });
    }
  }

  // Save schedule method
  void _saveSchedule() async {
    if (selectedChildName == null || selectedParentUsername == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon pilih nama anak dan nama orang tua')),
      );
      return;
    }

    // Data untuk Firestore
    final scheduleData = {
      'name': selectedChildName, // Nama anak
      'username': selectedParentUsername, // Nama orang tua
      'date': Timestamp.fromDate(
          DateFormat('yyyy-MM-dd').parse(dateController.text)),
      'timeStart': timeStartController.text,
      'timeEnd': timeEndController.text,
      'address': addressController.text,
      'category': selectedCategory,
      'course': selectedCourse,
      'price': int.parse(priceController.text), // Harga sebagai integer
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      if (widget.scheduleData == null) {
        await FirebaseFirestore.instance
            .collection('schedules')
            .add(scheduleData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal berhasil disimpan')),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('schedules')
            .doc(widget.scheduleData!['id'])
            .update(scheduleData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal berhasil diperbarui')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void loadScheduleData(String docId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('schedules')
          .doc(docId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          selectedChildName = data['name'];
          selectedParentUsername = data['username'];
          dateController.text = data['date'] != null
              ? DateFormat('yyyy-MM-dd')
                  .format((data['date'] as Timestamp).toDate())
              : '';
          timeStartController.text = data['timeStart'] ?? '';
          timeEndController.text = data['timeEnd'] ?? '';
          addressController.text = data['address'] ?? '';
          priceController.text = data['price']?.toString() ?? '';
          selectedCategory = data['category'];
          selectedCourse = data['course'];
        });
      } else {
        print("Document with ID $docId not found.");
      }
    } catch (e) {
      print("Error loading schedule data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChildrenNames(); // Tetap ambil daftar anak
    courseController.fetchAllNameCourse(); // Ambil daftar kursus
    // Mengambil data dari arguments
    final args = Get.arguments;
    if (args != null && args['data'] != null) {
      var scheduleData = args['data'];
      scheduleId = args['id'];

      // Mengisi field dengan data yang ada
      selectedChildName = scheduleData['name'] ?? '';
      selectedParentUsername = scheduleData['username'] ?? '';
      selectedCategory = scheduleData['category'] ?? '';
      selectedCourse = scheduleData['course'] ?? '';
      dateController.text = scheduleData['date'] != null
          ? DateFormat('yyyy-MM-dd')
              .format((scheduleData['date'] as Timestamp).toDate())
          : '';
      priceController.text = scheduleData['price']?.toString() ?? '';
      timeStartController.text = scheduleData['timeStart'] ?? '';
      timeEndController.text = scheduleData['timeEnd'] ?? '';
      addressController.text = scheduleData['address'] ?? '';
    }
  }

  // Metode untuk update schedule
  Future<void> updateSchedule() async {
    final updatedSchedule = {
      'name': selectedChildName,
      'category': selectedCategory,
      'course': selectedCourse,
      'date': dateController.text,
      'timeStart': timeStartController.text,
      'timeEnd': timeEndController.text,
      'address': addressController.text,
      // tambahkan field lain jika ada
    };

    try {
      await scheduleController.updateSchedule(scheduleId, updatedSchedule);
      Get.back(); // Kembali setelah update berhasil
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui jadwal: $e');
    }
    if (widget.isEditMode && widget.scheduleData != null) {
      // Ambil data jadwal untuk edit
      selectedChildName = widget.scheduleData!['name'];
      selectedParentUsername = widget.scheduleData!['username'];
      dateController.text = widget.scheduleData!['date'] != null
          ? DateFormat('yyyy-MM-dd')
              .format((widget.scheduleData!['date'] as Timestamp).toDate())
          : '';
      timeStartController.text = widget.scheduleData!['timeStart'] ?? '';
      timeEndController.text = widget.scheduleData!['timeEnd'] ?? '';
      addressController.text = widget.scheduleData!['address'] ?? '';
      priceController.text = widget.scheduleData!['price']?.toString() ?? '';
      selectedCategory = widget.scheduleData!['category'];
      selectedCourse = widget.scheduleData!['course'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.scheduleData != null; // Mode Edit atau Tambah

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Jadwal',
          style: TextStylesConstant.nunitoHeading20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Anak',
                style: TextStylesConstant.nunitoHeading16,
              ),
              isDropdownLoading
                  ? Center(child: CircularProgressIndicator())
                  : DropdownSearch<String>(
                      items: (String filter, LoadProps? loadProps) async {
                        return childrenWithParents.map((data) {
                          return '${data['name']} (${data['username']})';
                        }).toList();
                      },
                      popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        constraints: const BoxConstraints(
                            maxHeight: 400), // Tinggi maksimal popup
                        menuProps: MenuProps(
                          borderRadius:
                              BorderRadius.circular(10), // Radius sudut popup
                          backgroundColor: ColorsConstant
                              .neutral50, // Warna latar belakang popup
                          elevation: 4, // Efek bayangan
                        ),
                        itemBuilder:
                            (context, item, isSelected, isHighlighted) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
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
                                  ? TextStylesConstant.nunitoCaptionBold
                                      .copyWith(
                                      color: Colors
                                          .white, // Warna teks jika dipilih
                                      fontSize: 16, // Ukuran teks jika dipilih
                                    )
                                  : TextStylesConstant.nunitoButtonBold
                                      .copyWith(
                                      color: ColorsConstant
                                          .neutral800, // Warna teks default
                                      fontSize: 14, // Ukuran teks default
                                    ),
                            ),
                          );
                        },
                      ),
                      decoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStylesConstant.nunitoCaptionBold,
                          decoration: InputDecoration(
                            hintText: 'Pilih Nama Anak',
                            hintStyle: TextStylesConstant.nunitoCaptionBold,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: ColorsConstant.neutral200,
                              ),
                            ),
                          )),
                      onChanged: (value) {
                        setState(() {
                          // Pecahkan nilai untuk mengambil nama anak dan nama orang tua
                          final split = value?.split(' (');
                          if (split != null && split.length > 1) {
                            selectedChildName = split[0];
                            selectedParentUsername = split[1]
                                .replaceAll(')', ''); // Hilangkan tanda ')'
                          }
                        });
                      },
                      selectedItem: selectedChildName != null &&
                              selectedParentUsername != null
                          ? '$selectedChildName ($selectedParentUsername)'
                          : null,
                    ),
              const SizedBox(height: 14),
              Text('Category', style: TextStylesConstant.nunitoHeading16),
              DropdownSearch<String>(
                  items: (String filter, LoadProps? loadProps) async {
                    return categories.map((category) {
                      return '$category';
                    }).toList();
                  },
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: const BoxConstraints(
                        maxHeight: 400), // Tinggi maksimal popup
                    menuProps: MenuProps(
                      borderRadius:
                          BorderRadius.circular(10), // Radius sudut popup
                      backgroundColor: ColorsConstant
                          .neutral50, // Warna latar belakang popup
                      elevation: 4, // Efek bayangan
                    ),
                    itemBuilder: (context, item, isSelected, isHighlighted) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                                  color:
                                      Colors.white, // Warna teks jika dipilih
                                  fontSize: 16, // Ukuran teks jika dipilih
                                )
                              : TextStylesConstant.nunitoButtonBold.copyWith(
                                  color: ColorsConstant
                                      .neutral800, // Warna teks default
                                  fontSize: 14, // Ukuran teks default
                                ),
                        ),
                      );
                    },
                  ),
                  decoratorProps: DropDownDecoratorProps(
                      baseStyle: TextStylesConstant.nunitoCaptionBold,
                      decoration: InputDecoration(
                        hintText: 'Pilih Category',
                        hintStyle: TextStylesConstant.nunitoCaptionBold,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsConstant.neutral200,
                          ),
                        ),
                      )),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  selectedItem: selectedCategory),
              const SizedBox(height: 14),
              Text('Course', style: TextStylesConstant.nunitoHeading16),
              Obx(() {
                if (courseController.courseNames.isEmpty) {
                  return Text(
                      'Tidak ada kursus tersedia'); // Tampilkan pesan jika kosong
                }
                return DropdownSearch<String>(
                  items: (String filter, LoadProps? loadProps) async {
                    return courseController.courseNames.map((name) {
                      return '$name';
                    }).toList();
                  },
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: const BoxConstraints(
                        maxHeight: 400), // Tinggi maksimal popup
                    menuProps: MenuProps(
                      borderRadius:
                          BorderRadius.circular(10), // Radius sudut popup
                      backgroundColor: ColorsConstant
                          .neutral50, // Warna latar belakang popup
                      elevation: 4, // Efek bayangan
                    ),
                    itemBuilder: (context, item, isSelected, isHighlighted) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                                  color:
                                      Colors.white, // Warna teks jika dipilih
                                  fontSize: 16, // Ukuran teks jika dipilih
                                )
                              : TextStylesConstant.nunitoButtonBold.copyWith(
                                  color: ColorsConstant
                                      .neutral800, // Warna teks default
                                  fontSize: 14, // Ukuran teks default
                                ),
                        ),
                      );
                    },
                  ),
                  decoratorProps: DropDownDecoratorProps(
                      baseStyle: TextStylesConstant.nunitoCaptionBold,
                      decoration: InputDecoration(
                        hintText: 'Pilih Course',
                        hintStyle: TextStylesConstant.nunitoCaptionBold,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsConstant.neutral200,
                          ),
                        ),
                      )),
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                    });
                  },
                  selectedItem: selectedCourse,
                );
              }),
              const SizedBox(height: 14),
              Text(
                'Alamat',
                style: TextStylesConstant.nunitoHeading16,
              ),
              GlobalTextFieldWidget(
                controller: addressController,
                hintText: "Masukkan Alamat",
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 14),
              Text(
                'Harga',
                style: TextStylesConstant.nunitoHeading16,
              ),
              GlobalTextFieldWidget(
                controller: priceController,
                hintText: "Masukkan Harga",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              Text(
                'Tanggal Bimbingan',
                style: TextStylesConstant.nunitoHeading16,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: GlobalTextFieldWidget(
                    controller: dateController,
                    hintText: "Pilih Tanggal",
                    keyboardType: TextInputType.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waktu Mulai',
                          style: TextStylesConstant.nunitoHeading16,
                        ),
                        GestureDetector(
                          onTap: () => _selectTime(context, true),
                          child: AbsorbPointer(
                            child: GlobalTextFieldWidget(
                              controller: timeStartController,
                              hintText: "Pilih Waktu Mulai",
                              keyboardType: TextInputType.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waktu Selesai',
                          style: TextStylesConstant.nunitoHeading16,
                        ),
                        GestureDetector(
                          onTap: () => _selectTime(context, false),
                          child: AbsorbPointer(
                            child: GlobalTextFieldWidget(
                              controller: timeEndController,
                              hintText: "Pilih Waktu Selesai",
                              keyboardType: TextInputType.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              const SizedBox(height: 26),
              GlobalButtonWidget(
                text: isEditMode ? 'Update Jadwal' : 'Simpan Jadwal',
                onTap: _saveSchedule,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
