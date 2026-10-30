import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    // Membaca file JSON dari folder assets.
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    // Mengubah teks JSON menjadi Map.
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Mengambil daftar mata kuliah.
    final list = data['courses'] as List<dynamic>;

    // Mengubah setiap data Map menjadi object Course.
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}