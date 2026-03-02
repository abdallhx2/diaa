// ============================================================
// ملف اختبار أساسي — Flutter Test Main
// الغرض: التأكد من أن المشروع يعمل + الاتصال بالـ Backend
// التشغيل: غيّر main.dart مؤقتاً لاستدعاء هذا الملف
//   في main.dart: import 'test_main.dart' as test; → test.main()
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu Smart - اختبار',
      theme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90D9)),
        useMaterial3: true,
      ),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  String _backendStatus = '⏳ جاري الاختبار...';
  String _firebaseStatus = '⏳ جاري الاختبار...';
  bool _backendOk = false;
  bool _firebaseOk = false;
  bool _testing = true;

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    setState(() => _testing = true);

    // --- 1. اختبار الاتصال بالـ Backend ---
    await _testBackend();

    // --- 2. اختبار Firebase ---
    await _testFirebase();

    setState(() => _testing = false);
  }

  Future<void> _testBackend() async {
    try {
      // TODO: غيّر الرابط حسب بيئتك
      const apiUrl = 'http://10.0.2.2:8000'; // Android emulator → localhost
      // const apiUrl = 'http://localhost:8000'; // iOS simulator / Web

      // استخدم http package بدل dio للاختبار البسيط
      // import 'package:http/http.dart' as http;
      // final response = await http.get(Uri.parse(apiUrl));

      // مؤقتاً — نحاكي الاختبار
      await Future.delayed(const Duration(seconds: 1));

      // TODO: فعّل الكود أعلاه بعد تثبيت http package
      setState(() {
        _backendStatus = '⚠️ فعّل كود الاختبار في _testBackend()';
        _backendOk = false;
      });
    } catch (e) {
      setState(() {
        _backendStatus = '❌ فشل: $e';
        _backendOk = false;
      });
    }
  }

  Future<void> _testFirebase() async {
    try {
      // TODO: تأكد من إعداد Firebase أولاً
      // import 'package:firebase_core/firebase_core.dart';
      // await Firebase.initializeApp();

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _firebaseStatus = '⚠️ فعّل Firebase في _testFirebase()';
        _firebaseOk = false;
      });
    } catch (e) {
      setState(() {
        _firebaseStatus = '❌ فشل: $e';
        _firebaseOk = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('🔍 اختبار Edu Smart'),
          centerTitle: true,
          backgroundColor: const Color(0xFF4A90D9),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العنوان
              const Text(
                'المساعد التعليمي الذكي',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'اختبار الاتصال بالخدمات',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // بطاقة Flutter
              _buildTestCard(
                title: '✅ Flutter',
                subtitle: 'المشروع يعمل بنجاح',
                isOk: true,
              ),
              const SizedBox(height: 12),

              // بطاقة Backend
              _buildTestCard(
                title: '🖥️ Backend (FastAPI)',
                subtitle: _backendStatus,
                isOk: _backendOk,
              ),
              const SizedBox(height: 12),

              // بطاقة Firebase
              _buildTestCard(
                title: '🔥 Firebase',
                subtitle: _firebaseStatus,
                isOk: _firebaseOk,
              ),

              const Spacer(),

              // زر إعادة الاختبار
              ElevatedButton.icon(
                onPressed: _testing ? null : _runTests,
                icon: _testing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_testing ? 'جاري الاختبار...' : 'إعادة الاختبار'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String subtitle,
    required bool isOk,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(
          isOk ? Icons.check_circle : Icons.error_outline,
          color: isOk ? Colors.green : Colors.orange,
          size: 36,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
