import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ui_fundamentals/main.dart';
import 'package:flutter_ui_fundamentals/providers/course_provider.dart';
import 'package:flutter_ui_fundamentals/repositories/course_repository.dart';
import 'package:flutter_ui_fundamentals/services/course_api_service.dart';

void main() {
  testWidgets('Course Explorer berhasil dibangun dengan Provider',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CourseProvider(
          CourseRepository(
            CourseApiService('https://course-api-pearl.vercel.app'),
          ),
        ),
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Memastikan aplikasi berhasil ditampilkan.
    expect(find.byType(MyApp), findsOneWidget);

    // Memastikan tidak ada exception saat aplikasi dibangun.
    expect(tester.takeException(), isNull);
  });
}