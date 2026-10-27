import 'package:flutter/material.dart';
import 'course_state.dart';

const String studentName = 'Gede Rio Virgiawan Saputra';
const String studentId = '2415051015';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}

// ======================================================
// RESPONSIVE SHELL
// ======================================================

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  NavigationBar buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: changePage,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: changePage,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: pages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(
                child: pages[selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ======================================================
// HOME PAGE
// ======================================================

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
                    const Icon(
                      Icons.explore,
                      size: 50,
                    ),
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

// ======================================================
// COURSE DATA
// ======================================================

const List<Map<String, dynamic>> courses = [
  {
    'code': 'MOB01',
    'title': 'Git & GitHub',
    'credits': 2,
    'status': 'done',
  },
  {
    'code': 'MOB02',
    'title': 'Dart Fundamentals',
    'credits': 2,
    'status': 'done',
  },
  {
    'code': 'MOB03',
    'title': 'Flutter UI Fundamentals',
    'credits': 3,
    'status': 'active',
  },
  {
    'code': 'MOB04',
    'title': 'Navigation',
    'credits': 2,
    'status': 'planned',
  },
  {
    'code': 'MOB05',
    'title': 'State Management',
    'credits': 3,
    'status': 'planned',
  },
];

// ======================================================
// COURSES PAGE
// ======================================================

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final Set<String> favoriteCourses = {};

  bool showDetail = false;

  Future<void> openCourseDetail(
    Map<String, dynamic> course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(
          course: course,
          isFavorite: favoriteCourses.contains(course['code']),
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        favoriteCourses.add(course['code']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${course['title']} ditambahkan ke favorite.',
          ),
        ),
      );
    }
  }

  void toggleFavorite(Map<String, dynamic> course) {
    setState(() {
      if (favoriteCourses.contains(course['code'])) {
        favoriteCourses.remove(course['code']);
      } else {
        favoriteCourses.add(course['code']);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favoriteCourses.contains(course['code'])
              ? 'Course ditambahkan ke favorite'
              : 'Course dihapus dari favorite',
        ),
      ),
    );
  }

  void clearFavorites() {
    setState(() {
      favoriteCourses.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua favorite dihapus.'),
      ),
    );
  }

  void toggleDetail() {
    setState(() {
      showDetail = !showDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool expanded = constraints.maxWidth >= 840;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Course',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '$studentId - $studentName',
                ),
                const SizedBox(height: 20),

                FavoriteSummary(
                  favoriteCourses: favoriteCourses,
                  onClearFavorites: clearFavorites,
                ),
                
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: toggleDetail,
                  icon: Icon(
                    showDetail ? Icons.visibility_off : Icons.visibility,
                  ),
                  label: Text(
                    showDetail ? 'Sembunyikan Detail' : 'Tampilkan Detail',
                  ),
                ),

                const SizedBox(height: 16),

                if (!expanded)
                  Column(
                    children: courses.map((course) {
                      return Column(
                        children: [
                          CourseCard(
                            course: course,
                            isFavorite:
                                favoriteCourses.contains(course['code']),
                            onTap: () => openCourseDetail(course),
                            onFavorite: () => toggleFavorite(course),
                          ),
                          if (showDetail)
                            Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Detail: ${course['title']} memiliki '
                                  '${course['credits']} SKS dan status '
                                  '${course['status']}.',
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return CourseCard(
                        course: course,
                        isFavorite:
                            favoriteCourses.contains(course['code']),
                        onTap: () => openCourseDetail(course),
                        onFavorite: () => toggleFavorite(course),
                      );
                    },
                  ),

                // --- BAGIAN EKSPERIMEN DIPINDAHKAN KE BAWAH SINI ---
                const SizedBox(height: 24),
                const Divider(),
                const Text(
                  'Eksperimen State Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const ValueNotifierDemo(),
                const ChangeNotifierDemo(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======================================================
// FAVORITE SUMMARY WIDGET
// ======================================================

class FavoriteSummary extends StatelessWidget {
  final Set<String> favoriteCourses;
  final VoidCallback onClearFavorites;

  const FavoriteSummary({
    super.key,
    required this.favoriteCourses,
    required this.onClearFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jumlah course favorit: ${favoriteCourses.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: favoriteCourses.isEmpty ? null : onClearFavorites,
              child: const Text('Hapus Semua'),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// VALUE NOTIFIER DEMO WIDGET
// ======================================================

class ValueNotifierDemo extends StatefulWidget {
  const ValueNotifierDemo({super.key});

  @override
  State<ValueNotifierDemo> createState() =>
      _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<ValueNotifierDemo> {
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eksperimen ValueNotifier',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 12),
            const Text('Nilai counter:'),

            ValueListenableBuilder<int>(
              valueListenable: counter,
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    counter.value++;
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (counter.value > 0) {
                      counter.value--;
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CHANGE NOTIFIER DEMO WIDGET
// ======================================================

class ChangeNotifierDemo extends StatefulWidget {
  const ChangeNotifierDemo({super.key});

  @override
  State<ChangeNotifierDemo> createState() =>
      _ChangeNotifierDemoState();
}

class _ChangeNotifierDemoState extends State<ChangeNotifierDemo> {
  final CourseState courseState = CourseState();

  @override
  void dispose() {
    courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: courseState,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Eksperimen ChangeNotifier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('$studentId - $studentName'),
                const SizedBox(height: 12),
                Text(
                  'Jumlah favorite: '
                  '${courseState.favorites.length}',
                ),
                const SizedBox(height: 8),
                Text(
                  courseState.favorites.isEmpty
                      ? 'Belum ada favorite.'
                      : 'Favorite: '
                          '${courseState.favorites.join(', ')}',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final id in [
                      'MOB01',
                      'MOB02',
                      'MOB03',
                    ])
                      ElevatedButton(
                        onPressed: () {
                          courseState.toggleFavorite(id);
                        },
                        child: Text(
                          courseState.favorites.contains(id)
                              ? 'Hapus $id'
                              : 'Pilih $id',
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ======================================================
// REUSABLE COURSE CARD
// ======================================================

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
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
                      course['title'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${course['code']} • '
                      '${course['credits']} SKS',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${course['status']}',
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// COURSE DETAIL PAGE
// ======================================================

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              studentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(studentId),
            const SizedBox(height: 30),
            const Icon(
              Icons.school,
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              course['title'],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kode: ${course['code']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Credits: ${course['credits']} SKS',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${course['status']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Pilih sebagai Favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// PROFILE PAGE
// ======================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
            const FeedbackForm(),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// REUSABLE FEEDBACK FORM
// ======================================================

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController namaController =
      TextEditingController(text: studentName);

  final TextEditingController nimController =
      TextEditingController(text: studentId);

  final TextEditingController komentarController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  Future<void> submitFeedback() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Apakah feedback ingin dikirim?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback berhasil dikirim.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: komentarController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  hintText: 'Minimal 5 karakter',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  }
                  if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitFeedback,
                  child: const Text('Kirim Feedback'),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 18),
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Mengirim feedback...'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}