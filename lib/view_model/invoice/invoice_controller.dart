import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  RxList<Map<String, dynamic>> invoices = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> allInvoices =
      <Map<String, dynamic>>[].obs; //Menyimpan semua tagihan
  RxList<Map<String, dynamic>> filteredInvoices =
      <Map<String, dynamic>>[].obs; // Tagihan yang difilter
  RxList<Map<String, dynamic>> filteredAdminInvoices =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllInvoices();
    filteredInvoices.value = allInvoices;
    ever(allInvoices, (List<Map<String, dynamic>> _) {
      filteredAdminInvoices.value = allInvoices;
    });
  }

  // Method untuk mengambil invoice berdasarkan nama anak
  Future<void> fetchInvoicesForChild(String childName) async {
    try {
      isLoading.value = true;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('invoice')
          .where('name', isEqualTo: childName)
          .get();

      // Simpan semua invoice
      allInvoices.value = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();

      // Set filteredInvoices ke allInvoices awalnya
      filteredInvoices.value = allInvoices;
    } catch (e) {
      print("Error fetching invoices: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Method untuk mengambil semua data invoice
  Future<void> fetchAllInvoices() async {
    try {
      isLoading.value = true;
      final querySnapshot =
          await FirebaseFirestore.instance.collection('invoice').get();

      // Simpan data dari Firebase
      allInvoices.value = querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // Default tampilkan semua invoice
      filteredAdminInvoices.value = allInvoices;
    } catch (e) {
      print("Error fetching invoices: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk menghapus invoice berdasarkan ID
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoice')
          .doc(invoiceId)
          .delete();
    } catch (e) {
      print("Error deleting invoice: $e");
    }
  }

// Method untuk memfilter invoice berdasarkan status pembayaran
  void filterInvoices(String filter) {
    if (filter == 'All') {
      filteredInvoices.value = allInvoices;
    } else if (filter == 'paid') {
      filteredInvoices.value =
          allInvoices.where((invoice) => invoice['success'] == true).toList();
    } else if (filter == 'unpaid') {
      filteredInvoices.value =
          allInvoices.where((invoice) => invoice['success'] == false).toList();
    }
  }

  void filterAdminInvoices(String filter) {
    if (filter == 'All') {
      filteredAdminInvoices.value = allInvoices;
    } else if (filter == 'paid') {
      filteredAdminInvoices.value =
          allInvoices.where((invoice) => invoice['success'] == true).toList();
    } else if (filter == 'unpaid') {
      filteredAdminInvoices.value =
          allInvoices.where((invoice) => invoice['success'] == false).toList();
    }
  }

  //Method untuk menampilkan ringkasan tagihan
  Map<String, int> getInvoiceSummary() {
    final paidCount =
        allInvoices.where((invoice) => invoice['success'] == true).length;
    final unpaidCount =
        allInvoices.where((invoice) => invoice['success'] == false).length;
    final totalCount = allInvoices.length;

    return {'paid': paidCount, 'unpaid': unpaidCount, 'total': totalCount};
  }

  //Metode untuk searchbar pada halaman admin
  // Metode untuk searchbar pada halaman admin
  void searchInvoices(String query) {
    if (query.isEmpty) {
      // Jika query kosong, tampilkan semua invoice
      filteredAdminInvoices.assignAll(allInvoices);
    } else {
      filteredAdminInvoices.assignAll(
        allInvoices.where((invoice) {
          final name = invoice['name']?.toLowerCase() ?? ''; // Nama invoice
          final category =
              invoice['category']?.toLowerCase() ?? ''; // Kategori invoice

          return name.contains(query.toLowerCase()) ||
              category.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }
}
