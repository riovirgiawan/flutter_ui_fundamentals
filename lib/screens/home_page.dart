import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';
import '../pages/edit_course_page.dart';

const String studentName = 'Gede Rio Virgiawan Saputra';
const String studentId = '2415051015';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<CourseProvider>();

      if (provider.courses.isEmpty && !provider.isLoading) {
        provider.loadCourses();
      }
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.teal.shade700;
      case 'active':
        return Colors.blue.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Sedang Berjalan';
      default:
        return 'Terencana';
    }
  }

  void openDetail(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );
  }

  void openEdit(BuildContext context, Course course) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditCoursePage(course: course),
    ),
  );
}

  Widget summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB7D5E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF24547A), size: 25),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF60758A),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF23496D),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget courseItem(BuildContext context, Course course) {
    final color = statusColor(course.status);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFFBFDFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFC7D8E8)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        onTap: () => openDetail(context, course),
        title: Text(
          course.title,
          style: const TextStyle(
            color: Color(0xFF23496D),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${course.code} • ${course.credits} SKS'),
              const SizedBox(height: 7),
              Text(
                statusText(course.status),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF24547A),
              ),
              tooltip: 'Edit Course',
              onPressed: () => openEdit(context, course),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 17,
              color: Color(0xFF60758A),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Explorer v2',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth < 600 ? 20.0 : 32.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF5FA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '$studentId • $studentName',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF23496D),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          summaryCard(
                            icon: Icons.school_outlined,
                            title: 'Courses',
                            value: '${provider.courses.length}',
                          ),
                          const SizedBox(width: 14),
                          summaryCard(
                            icon: Icons.favorite_outline,
                            title: 'Favorites',
                            value: '${provider.favorites.length}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'My Courses',
                        style: TextStyle(
                          color: Color(0xFF23496D),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (provider.isLoading && provider.courses.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (provider.error != null)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Gagal memuat course:\n${provider.error}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: provider.loadCourses,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      else if (provider.courses.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('Belum ada course.'),
                          ),
                        )
                      else
                        ...provider.courses
                            .map((course) => courseItem(context, course)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}