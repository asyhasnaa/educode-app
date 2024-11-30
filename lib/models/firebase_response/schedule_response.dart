import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalModel {
  String jadwalId;
  String name;
  String childId;
  Timestamp tanggal; // Store as Timestamp
  TimeOfDay waktuStart;
  TimeOfDay waktuEnd;
  String category;
  String alamat;
  String username;

  JadwalModel({
    required this.jadwalId,
    required this.name,
    required this.childId,
    required this.tanggal,
    required this.waktuStart,
    required this.waktuEnd,
    required this.category,
    required this.alamat,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'jadwalId': jadwalId,
      'name': name,
      'childId': childId,
      'tanggal': tanggal, // Store as Timestamp
      'waktuStart': _timeOfDayToString(waktuStart),
      'waktuEnd': _timeOfDayToString(waktuEnd),
      'category': category,
      'alamat': alamat,
      'username': username,
    };
  }

  // Helper function to convert TimeOfDay to string
  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
