import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.school,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${course.code} • ${course.credits} SKS',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${course.status}',
                    ),
                  ],
                ),
              ),
              Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite(course.code);

                  return IconButton(
                    onPressed: () {
                      context
                          .read<CourseProvider>()
                          .toggleFavorite(course.code);

                      ScaffoldMessenger.of(context)
                          .hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? '${course.title} dihapus dari favorite.'
                                : '${course.title} ditambahkan ke favorite.',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}