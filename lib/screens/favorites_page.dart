import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import 'course_detail_page.dart';

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
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: provider.isLoading && provider.courses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : favoriteCourses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 65,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada course favorit.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Tambahkan course melalui halaman detail.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: favoriteCourses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final course = favoriteCourses[index];

                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(
                                  color: Color(0xFFC7D8E8),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF23496D),
                                  ),
                                ),
                                subtitle: Text(
                                  '${course.code} • ${course.credits} SKS',
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context
                                        .read<CourseProvider>()
                                        .toggleFavorite(course.code);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailPage(
                                        course: course,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );
  }
}