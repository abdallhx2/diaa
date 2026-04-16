import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class WritingQuizScreen extends StatefulWidget {
final String lessonId;
const WritingQuizScreen({super.key, required this.lessonId});

@override
State<WritingQuizScreen> createState() => _WritingQuizScreenState();
}

class _WritingQuizScreenState extends State<WritingQuizScreen> {
String? _selectedAnswer;
bool? _isCorrect;

@override
void initState() {
super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
context.read<QuizProvider>().loadQuizzes(widget.lessonId, 'writing');
});
}

Future<void> _selectAnswer(String answer, String quizId) async {
setState(() => _selectedAnswer = answer);

final quizProvider = context.read<QuizProvider>();
final isCorrect = await quizProvider.submitAnswer(quizId, answer);

setState(() => _isCorrect = isCorrect);

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

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: const Text('اختبار الكتابة'),
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
body: Consumer<QuizProvider>(
builder: (_, quizProvider, __) {
if (quizProvider.isLoading) {
return const Center(
child: CircularProgressIndicator(color: Colors.green),
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
color: Colors.green,
minHeight: 8,
),
],
),
),

// السؤال
Padding(
padding: const EdgeInsets.all(20),
child: Text(
quiz.questionText,
style: const TextStyle(
fontSize: 22,
height: 1.5,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
textDirection: TextDirection.rtl,
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
fontSize: 18,
color: _selectedAnswer == option
? Colors.white
: Colors.black87,
),
textAlign: TextAlign.center,
textDirection: TextDirection.rtl,
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

Color _getOptionColor(String option) {
if (_selectedAnswer != option) return Colors.white;
if (_isCorrect == null) return Colors.green;
return _isCorrect! ? Colors.green : Colors.red;
}

Color _getOptionBorderColor(String option) {
if (_selectedAnswer != option) return Colors.grey[300]!;
if (_isCorrect == null) return Colors.green;
return _isCorrect! ? Colors.green : Colors.red;
}
}