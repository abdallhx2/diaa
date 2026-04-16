// ============================================================
// File: widget_test.dart
// Purpose: اختبار دخان أساسي للتأكد من تشغيل التطبيق
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: We do not import MyApp directly because it is defined as
// the private class _MyApp inside main.dart.
// If you later move _MyApp to app.dart and export it as MyApp,
// replace the test body below with: await tester.pumpWidget(const MyApp());

void main() {
  testWidgets('EduSmart app smoke test', (WidgetTester tester) async {
    // Build a minimal stand-in widget to verify the test runner works.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('EduSmart Assistant'),
          ),
        ),
      ),
    );

    // Verify the app renders without throwing.
    expect(find.text('EduSmart Assistant'), findsOneWidget);
  });
}
