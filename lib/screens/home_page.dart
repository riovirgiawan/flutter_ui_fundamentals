import 'package:flutter/material.dart';

const String studentName = 'Gede Rio Virgiawan Saputra';
const String studentId = '2415051015';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 46,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              studentName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              studentId,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.explore, size: 50),
                    const SizedBox(height: 12),
                    const Text(
                      'Course Explorer',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jelajahi berbagai course Pemrograman Mobile '
                      'dalam satu aplikasi yang responsif.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Silakan pilih menu Courses untuk melihat course.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Mulai Menjelajah'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}