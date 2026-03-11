import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class QuizResultScreen extends StatelessWidget {
const QuizResultScreen({super.key});

@override
Widget build(BuildContext context) {
// Step 2: قراءة النتيجة
final quizProvider = context.read<QuizProvider>();
final double score = quizProvider.score;
final int correct = (score / 100 * 5).round();
final bool isGoodScore = score >= 60;

// Step 3: بناء الواجهة
return Scaffold(
backgroundColor: Colors.white,
body: SafeArea(
child: Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [

// أيقونة تحفيزية
Icon(
isGoodScore ? Icons.star_rounded : Icons.sentiment_satisfied_alt,
size: 120,
color: isGoodScore
? const Color(0xFFFFD700) // ذهبي للنجاح
: const Color(0xFF4A1A7A), // بنفسجي للتشجيع
),

const SizedBox(height: 24),

// الدرجة الكبيرة
Text(
'$correct/5',
style: TextStyle(
fontSize: 72,
fontWeight: FontWeight.bold,
color: isGoodScore ? Colors.green : Colors.orange,
),
),

// النسبة المئوية
Text(
'${score.round()}%',
style: const TextStyle(
fontSize: 28,
color: Colors.grey,
),
),

const SizedBox(height: 16),

// رسالة تحفيزية
Text(
isGoodScore ? '🌟 أحسنت! عمل رائع!' : '💪 لا بأس، حاول مرة أخرى!',
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),

const SizedBox(height: 48),

// زر إعادة الاختبار
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
quizProvider.reset();
Navigator.pop(context);
},
icon: const Icon(Icons.refresh),
label: const Text(
'إعادة الاختبار',
style: TextStyle(fontSize: 18),
),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.orange,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
),
),

const SizedBox(height: 12),

// زر العودة للوحة
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
quizProvider.reset();
Navigator.pushNamedAndRemoveUntil(
context,
AppRoutes.studentDashboard,
(route) => false,
);
},
icon: const Icon(Icons.home),
label: const Text(
'العودة للوحة',
style: TextStyle(fontSize: 18),
),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
),
),
],
),
),
),
),
);
}
}