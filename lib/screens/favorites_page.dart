import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final favoriteCourses = provider.courses
        .where((course) => provider.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursus Favorit'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text('Belum ada kursus favorit.'),
            )
          : ListView.builder(
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];

                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(course.title),
                  subtitle: Text(
                    '${course.code} • ${course.credits} SKS',
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(course.code);
                    },
                  ),
                );
              },
            ),
    );
  }
}