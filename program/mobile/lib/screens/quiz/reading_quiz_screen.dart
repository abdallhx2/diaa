import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class ReadingQuizScreen extends StatefulWidget {
final String lessonId;
const ReadingQuizScreen({super.key, required this.lessonId});

@override
State<ReadingQuizScreen> createState() => _ReadingQuizScreenState();
}

class _ReadingQuizScreenState extends State<ReadingQuizScreen> {
// Step 3: المتغيرات
String? _selectedAnswer;
bool? _isCorrect;

// Step 2: تحميل الأسئلة
@override
void initState() {
super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
context.read<QuizProvider>().loadQuizzes(widget.lessonId, 'reading');
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

// انتظري ثانية
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
title: const Text('اختبار القراءة'),
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

return Column(
children: [

// شريط التقدم
Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
Text(
'سؤال ${quizProvider.currentIndex + 1} من ${quizProvider.totalQuestions}',
style: const TextStyle(color: Colors.grey),
),
const SizedBox(height: 8),
LinearProgressIndicator(
value: quizProvider.progress,
backgroundColor: Colors.grey[200],
color: const Color(0xFF4A1A7A),
minHeight: 8,
),
],
),
),

// الكلمة الكبيرة
Padding(
padding: const EdgeInsets.all(24),
child: Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: const Color(0xFF4A1A7A).withOpacity(0.1),
borderRadius: BorderRadius.circular(16),
),
child: Text(
quiz.questionText,
style: const TextStyle(
fontSize: 48,
fontWeight: FontWeight.bold,
color: Color(0xFF4A1A7A),
),
textAlign: TextAlign.center,
),
),
),

// الخيارات
Expanded(
child: ListView(
padding: const EdgeInsets.symmetric(horizontal: 16),
children: quiz.options.map((option) => Padding(
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
fontSize: 20,
color: _selectedAnswer == option
? Colors.white
: Colors.black87,
),
textAlign: TextAlign.center,
),
),
),
)).toList(),
),
),
],
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