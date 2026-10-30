import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // Data mata kuliah dari Repository
  List<Course> courses = [];

  // Status pengambilan data
  bool isLoading = false;
  String? error;

  // Status penyimpanan data baru
  bool isSaving = false;

  // Shared state untuk favorites
  final Set<String> favorites = {};

  // Mengambil data mata kuliah melalui Repository
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Membuat mata kuliah baru melalui Repository
  Future<Course> createCourse(Course course) async {
    isSaving = true;
    notifyListeners();

    try {
      final createdCourse = await repository.createCourse(course);

      // Memuat ulang daftar agar data terbaru ditampilkan
      await loadCourses();

      return createdCourse;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Memeriksa apakah mata kuliah termasuk favorite
  bool isFavorite(String code) {
    return favorites.contains(code);
  }

  // Mengubah status favorite
  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }

    notifyListeners();
  }

  // Menghapus semua favorite
  void clearFavorites() {
    favorites.clear();
    notifyListeners();
  }

Future<void> updateCourse(int id, Course course) async {
  isSaving = true;
  notifyListeners();

  try {
    await repository.updateCourse(id, course);
    await loadCourses();
  } finally {
    isSaving = false;
    notifyListeners();
  }
}
}
