import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildrenController extends GetxController {
  var childrenWithParents = <Map<String, String>>[].obs;
  var isDropdownLoading = false.obs;

  // Method untuk mengambil data anak-anak dari Firestore
  Future<void> fetchChildrenNames() async {
    isDropdownLoading.value = true;
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, String>> fetchedChildren = [];
      for (var userDoc in usersSnapshot.docs) {
        String parentUsername = userDoc['username'];
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
      childrenWithParents.value = fetchedChildren;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching children names: $e");
      }
    } finally {
      isDropdownLoading.value = false;
    }
  }
}
