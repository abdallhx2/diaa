import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class QuizSelectionScreen extends StatelessWidget {
final String lessonId;
const QuizSelectionScreen({super.key, required this.lessonId});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: const Text('اختر نوع الاختبار'),
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [

// Step 3: اختبار القراءة
_buildQuizTypeCard(
context: context,
icon: Icons.menu_book,
title: 'اختبار القراءة',
description: 'اقرأ الكلمات واختر النطق الصحيح',
color: const Color(0xFF4A1A7A),
onTap: () => Navigator.pushNamed(
context,
AppRoutes.readingQuiz,
arguments: lessonId,
),
),

const SizedBox(height: 16),

// Step 4: اختبار الكتابة
_buildQuizTypeCard(
context: context,
icon: Icons.edit_note,
title: 'اختبار الكتابة',
description: 'أجب عن أسئلة الكتابة',
color: Colors.green,
onTap: () => Navigator.pushNamed(
context,
AppRoutes.writingQuiz,
arguments: lessonId,
),
),

const SizedBox(height: 16),

// Step 5: اختبار الاستيعاب
_buildQuizTypeCard(
context: context,
icon: Icons.psychology,
title: 'اختبار الاستيعاب',
description: 'اقرأ النص وأجب عن الأسئلة',
color: Colors.orange,
onTap: () => Navigator.pushNamed(
context,
AppRoutes.comprehensionQuiz,
arguments: lessonId,
),
),
],
),
),
);
}

// Step 6: بناء بطاقة نوع الاختبار
Widget _buildQuizTypeCard({
required BuildContext context,
required IconData icon,
required String title,
required String description,
required Color color,
required VoidCallback onTap,
}) {
return Card(
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(16),
child: Padding(
padding: const EdgeInsets.all(20),
child: Row(
textDirection: TextDirection.rtl,
children: [
// الأيقونة
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: color.withOpacity(0.15),
borderRadius: BorderRadius.circular(12),
),
child: Icon(icon, size: 48, color: color),
),

const SizedBox(width: 16),

// العنوان والوصف
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
title,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.right,
),
const SizedBox(height: 4),
Text(
description,
style: const TextStyle(
fontSize: 14,
color: Colors.grey,
),
textAlign: TextAlign.right,
),
],
),
),
],
),
),
),
);
}
}
