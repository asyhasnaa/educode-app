import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/global_widgets/global_text_field_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/view_model/home/get_children.dart';
import 'package:educode/models/firebase_response/tagihan_response.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  const GenerateInvoiceScreen({super.key});

  @override
  State<GenerateInvoiceScreen> createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<String> childrenNames = [];
  String? selectedChildName;
  String? selectedParentUsername;
  List<Map<String, String>> childrenWithParents = [];

  // final ChildrenData childrenData = ChildrenData();
  bool _success = false;
  List<Detail> _details = [];

  // void fetchChildrenNames() async {
  //   childrenNames = await childrenData.getChildrenNamesWithParents();
  //   setState(() {}); // Refresh UI setelah data anak didapatkan
  // }

  Future<void> fetchChildrenNames() async {
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

  void _generateInvoice() async {
    if (selectedChildName == null ||
        selectedChildName!.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mohon lengkapi semua field yang diperlukan')),
      );
      return;
    }

    try {
      // Parsing date untuk filter bulan
      DateTime selectedDate =
          DateFormat('yyyy-MM-dd').parse(dateController.text);
      DateTime startOfMonth =
          DateTime(selectedDate.year, selectedDate.month, 1);
      DateTime endOfMonth =
          DateTime(selectedDate.year, selectedDate.month + 1, 0);

      // Fetch schedules dari Firebase sesuai nama dan rentang bulan
      QuerySnapshot schedulesSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('name', isEqualTo: selectedChildName)
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      if (schedulesSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada jadwal untuk anak ini')),
        );
        return;
      }

      // Membuat list detail dari jadwal yang didapatkan (schedules)
      List<Detail> details = schedulesSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Detail(
          date: (data['date'] as Timestamp).toDate(),
          course: data['course'] ?? 'Unknown Course',
          price: data['price'] ?? 0, // Harga sudah berupa integer
        );
      }).toList();

      // Menghitung total harga dari semua detail (total menggunakan integer)
      int total = details.fold(0, (sum, item) => sum + item.price);

      // Format total dengan pemisah ribuan (menggunakan titik)
      String formattedTotal = NumberFormat('#,###', 'id_ID').format(total);

      //Generate nomor seri untuk invoice
      QuerySnapshot invoiceSnapshot =
          await FirebaseFirestore.instance.collection('invoice').get();
      int nextInvoiceNumber = invoiceSnapshot.docs.length + 1;

      //Format Nomor Invoice jadi 3 digit
      String invoiceNumber = nextInvoiceNumber.toString().padLeft(3, '0');
      // Menyimpan collection invoice ke Firebase
      final invoiceData = {
        'name': selectedChildName,
        'username': selectedParentUsername,
        'dateInvoice': Timestamp.fromDate(
            DateFormat('yyyy-MM-dd').parse(dateController.text)),
        'createdAt': FieldValue.serverTimestamp(),
        'success': _success,
        'invoiceNumber': invoiceNumber, // Nomor invoice dalam bentuk string
        'total':
            formattedTotal, // Total sekarang dalam bentuk double dengan 3 angka di belakang koma
        'details': details.map((detail) => detail.toMap()).toList(),
      };

      await FirebaseFirestore.instance.collection('invoice').add(invoiceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Tagihan berhasil generate')),
      );

      // Clear all fields after saving
      //  _nameController.clear();
      dateController.clear();

      setState(() {
        _details = [];
        _success = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan tagihan: $e')),
      );

      // Navigate back to HomeScreen
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChildrenNames();
    // fetchChildrenNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate Tagihan',
          style: TextStylesConstant.nunitoHeading20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tanggal Tagihan',
                  style: TextStylesConstant.nunitoHeading16,
                ),
                SizedBox(height: 8),
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
                Text(
                  'Nama Anak',
                  style: TextStylesConstant.nunitoHeading16,
                ),
                SizedBox(height: 8),
                DropdownSearch<String>(
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
                        hintText: 'Pilih Nama Anak',
                        hintStyle:
                            TextStylesConstant.nunitoCaptionBold.copyWith(
                          color: Colors.grey,
                        ),
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
                        selectedParentUsername =
                            split[1].replaceAll(')', ''); // Hilangkan tanda ')'
                      }
                    });
                  },
                  selectedItem: selectedChildName != null &&
                          selectedParentUsername != null
                      ? '$selectedChildName ($selectedParentUsername)'
                      : null,
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  title: Text(
                    "Lunas",
                    style: TextStylesConstant.nunitoHeading16,
                  ),
                  value: _success,
                  onChanged: (value) => setState(() => _success = value),
                ),
                const SizedBox(height: 26),
                GlobalButtonWidget(
                  text: 'Simpan Jadwal',
                  onTap: _generateInvoice,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
