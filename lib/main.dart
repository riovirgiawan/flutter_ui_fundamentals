
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Membaca data dari file JSON
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// Halaman utama dashboard
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Error state
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Gagal memuat data:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Memeriksa ketersediaan data
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Data tidak tersedia'),
              );
            }

            final data = snapshot.data!;
            final student =
                data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            // Menghitung total SKS
            final totalCredits = courses.fold<int>(
              0,
              (total, item) {
                final course = item as Map<String, dynamic>;
                return total + (course['credits'] as num).toInt();
              },
            );

            // Menghitung mata kuliah selesai
            final completed = courses.where((item) {
              final course = item as Map<String, dynamic>;
              return course['status'] == 'done';
            }).length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget identitas mahasiswa
                  ProfileCard(student: student),

                  const SizedBox(height: 20),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '2415051015 - Gede Rio Virgiawan Saputra - '
                          'Ini adalah teks yang sangat panjang untuk menguji layout',
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),

                  // Judul ringkasan
                  const Text(
                    'Ringkasan Pembelajaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dua kartu ringkasan
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Mata Kuliah',
                          value: '${courses.length}',
                          subtitle: '$completed selesai',
                          icon: Icons.menu_book,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Total SKS',
                          value: '$totalCredits',
                          subtitle: 'Kredit belajar',
                          icon: Icons.school,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Judul daftar mata kuliah
                  const Text(
                    'Daftar Mata Kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Daftar mata kuliah dari JSON
                  ...courses.map((item) {
                    final course =
                        item as Map<String, dynamic>;

                    return CourseTile(course: course);
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget identitas mahasiswa
class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const ProfileCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('NIM: ${student['nim']}'),
                  const SizedBox(height: 4),
                  Text('Semester: ${student['semester']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kartu ringkasan
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget item mata kuliah
class CourseTile extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseTile({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;

    final bool isDone = status == 'done';
    final bool isActive = status == 'active';

    final String statusText = isDone
        ? 'Selesai'
        : isActive
            ? 'Diproses'
            : 'Direncanakan';

    final Color statusColor = isDone
        ? Colors.green
        : isActive
            ? Colors.blue
            : Colors.orange;

    final IconData statusIcon = isDone
        ? Icons.check_circle
        : isActive
            ? Icons.play_circle
            : Icons.schedule;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.12),
          child: Icon(
            statusIcon,
            color: statusColor,
          ),
        ),
        title: Text(
          course['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${course['code']} • ${course['credits']} SKS',
          ),
        ),
        trailing: Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}