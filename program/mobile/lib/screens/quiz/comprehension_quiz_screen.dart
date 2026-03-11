import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class ComprehensionQuizScreen extends StatefulWidget {
final String lessonId;
const ComprehensionQuizScreen({super.key, required this.lessonId});

@override
State<ComprehensionQuizScreen> createState() =>
_ComprehensionQuizScreenState();
}

class _ComprehensionQuizScreenState extends State<ComprehensionQuizScreen> {
// Step 3: المتغيرات
String? _selectedAnswer;
bool? _isCorrect;

// Step 2: تحميل الأسئلة لما تفتح الشاشة
@override
void initState() {
super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
context.read<QuizProvider>().loadQuizzes(widget.lessonId, 'comprehension');
});
}

// Step 5: اختيار الجواب
Future<void> _selectAnswer(String answer, String quizId) async {
setState(() {
_selectedAnswer = answer;
});

final quizProvider = context.read<QuizProvider>();
final isCorrect = await quizProvider.submitAnswer(quizId, answer);

setState(() {
_isCorrect = isCorrect;
});

// انتظري ثانية ثم انتقلي للسؤال التالي
await Future.delayed(const Duration(seconds: 1));

if (quizProvider.isQuizComplete) {
Navigator.pushReplacementNamed(context, AppRoutes.quizResult);
} else {
setState(() {
_selectedAnswer = null;
_isCorrect = null;
quizProvider.nextQuestion();
});
}
}

// Step 4: بناء الواجهة
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: const Text('اختبار الاستيعاب'),
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
),
body: Consumer<QuizProvider>(
builder: (_, quizProvider, __) {
// شاشة التحميل
if (quizProvider.isLoading) {
return const Center(
child: CircularProgressIndicator(
color: Color(0xFF4A1A7A),
),
);
}

final quiz = quizProvider.currentQuiz;
if (quiz == null) {
return const Center(child: Text('لا توجد أسئلة'));
}

// تقسيم النص والسؤال
final parts = quiz.questionText.split('---');
final readingText = parts.isNotEmpty ? parts[0].trim() : '';
final questionText = parts.length > 1 ? parts[1].trim() : quiz.questionText;

return SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
// شريط التقدم
LinearProgressIndicator(
value: quizProvider.progress,
backgroundColor: Colors.grey[200],
color: const Color(0xFF4A1A7A),
minHeight: 8,
),

const SizedBox(height: 8),

// رقم السؤال
Text(
'السؤال ${quizProvider.currentIndex + 1} من ${quizProvider.totalQuestions}',
textAlign: TextAlign.center,
style: const TextStyle(color: Colors.grey),
),

const SizedBox(height: 16),

// بطاقة النص المقروء
Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Text(
readingText,
style: const TextStyle(
fontSize: 18,
height: 1.8,
),
textDirection: TextDirection.rtl,
textAlign: TextAlign.right,
),
),
),

const SizedBox(height: 16),

// السؤال
Text(
questionText,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
textDirection: TextDirection.rtl,
textAlign: TextAlign.right,
),

const SizedBox(height: 16),

// الخيارات
...quiz.options.map((option) => Padding(
padding: const EdgeInsets.symmetric(vertical: 6),
child: GestureDetector(
onTap: _selectedAnswer == null
? () => _selectAnswer(option, quiz.id)
: null,
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: _getOptionColor(option),
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: _getOptionBorderColor(option),
width: 2,
),
),
child: Text(
option,
style: TextStyle(
fontSize: 16,
color: _selectedAnswer == option
? Colors.white
: Colors.black87,
),
textDirection: TextDirection.rtl,
textAlign: TextAlign.right,
),
),
),
)),
],
),
);
},
),
);
}

// ألوان الخيارات
Color _getOptionColor(String option) {
if (_selectedAnswer != option) return Colors.white;
if (_isCorrect == null) return const Color(0xFF4A1A7A);
return _isCorrect! ? Colors.green : Colors.red;
}

Color _getOptionBorderColor(String option) {
if (_selectedAnswer != option) return Colors.grey[300]!;
if (_isCorrect == null) return const Color(0xFF4A1A7A);
return _isCorrect! ? Colors.green : Colors.red;
}
}