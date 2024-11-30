import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  final Timestamp dateInvoice;
  final String name;
  final String category;
  final bool success;
  final String total;
  final String invoiceNumber;
  final List<Detail> detail;

  InvoiceModel({
    required this.invoiceNumber,
    required this.dateInvoice,
    required this.name,
    required this.category,
    required this.success,
    required this.total,
    required this.detail,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> data) {
    return InvoiceModel(
      invoiceNumber: data['invoiceNumber'] ?? '',
      dateInvoice: data['dateInvoice'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      success: data['success'] ?? false,
      total: data['total'] ?? '',
      detail: (data['details'] as List<dynamic>? ?? [])
          .map((detailData) => Detail.fromMap(detailData))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'dateInvoice': dateInvoice,
      'name': name,
      'category': category,
      'lunas': success,
      'total': total,
      'details': detail.map((det) => det.toMap()).toList(),
    };
  }
}

class Detail {
  DateTime date;
  String course;
  int price;

  Detail({
    required this.date,
    required this.course,
    required this.price,
  });

  factory Detail.fromMap(Map<String, dynamic> data) {
    return Detail(
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      course: data['course'] ?? 'Unknown Course',
      price: data['price'] ??
          0, // Tidak perlu parsing, cukup ambil sebagai integer
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'course': course,
      'price': price, // Simpan sebagai integer
    };
  }
}
