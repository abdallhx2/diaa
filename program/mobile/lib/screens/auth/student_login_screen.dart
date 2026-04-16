import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/services/auth_service.dart';

class StudentLoginScreen extends StatefulWidget {
const StudentLoginScreen({super.key});

@override
State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
// Step 2: المتغيرات
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
bool _isLoading = false;
bool _obscurePassword = true;

// Step 4: تسجيل الدخول
Future<void> _login() async {
if (!_formKey.currentState!.validate()) return;

setState(() => _isLoading = true);

try {
await context.read<AuthProvider>().login(
email: _emailController.text.trim(),
password: _passwordController.text,
role: 'student',
);

Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);

} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(e.toString()),
backgroundColor: Colors.red,
),
);
} finally {
setState(() => _isLoading = false);
}
}

// Step 5: نسيت كلمة المرور
Future<void> _resetPassword() async {
final emailController = TextEditingController();

await showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text(
'نسيت كلمة المرور؟',
textAlign: TextAlign.right,
),
content: TextFormField(
controller: emailController,
textDirection: TextDirection.ltr,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'البريد الإلكتروني',
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text('إلغاء'),
),
ElevatedButton(
onPressed: () async {
try {
await AuthService().resetPassword(emailController.text.trim());
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('تم إرسال رابط إعادة تعيين كلمة المرور'),
backgroundColor: Colors.green,
),
);
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(e.toString()),
backgroundColor: Colors.red,
),
);
}
},
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
),
child: const Text('إرسال'),
),
],
),
);
}

// Step 6: dispose
@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

// Step 3: بناء الواجهة
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
iconTheme: const IconThemeData(color: Color(0xFF4A1A7A)),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [

// الشعار
const Icon(
Icons.menu_book,
size: 80,
color: Color(0xFF4A1A7A),
),
const SizedBox(height: 8),
const Text(
'ضياء',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Color(0xFF4A1A7A),
),
),

const SizedBox(height: 8),

const Text(
'تسجيل دخول الطالب',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 20,
color: Colors.grey,
),
),

const SizedBox(height: 32),

// حقل البريد
TextFormField(
controller: _emailController,
textDirection: TextDirection.ltr,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'البريد الإلكتروني',
hintText: 'أدخل بريدك الإلكتروني',
prefixIcon: const Icon(Icons.email_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Color(0xFF4A1A7A)),
),
),
validator: (v) =>
!v!.contains('@') ? 'بريد إلكتروني غير صالح' : null,
),

const SizedBox(height: 16),

// حقل كلمة المرور
TextFormField(
controller: _passwordController,
obscureText: _obscurePassword,
decoration: InputDecoration(
labelText: 'كلمة المرور',
hintText: 'أدخل كلمة المرور',
prefixIcon: const Icon(Icons.lock_outlined),
suffixIcon: IconButton(
icon: Icon(_obscurePassword
? Icons.visibility_off
: Icons.visibility),
onPressed: () => setState(
() => _obscurePassword = !_obscurePassword),
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Color(0xFF4A1A7A)),
),
),
validator: (v) =>
v!.length < 6 ? 'كلمة المرور قصيرة جداً' : null,
),

const SizedBox(height: 8),

// نسيت كلمة المرور
Align(
alignment: Alignment.centerLeft,
child: TextButton(
onPressed: _resetPassword,
child: const Text(
'نسيت كلمة المرور؟',
style: TextStyle(color: Color(0xFF4A1A7A)),
),
),
),

const SizedBox(height: 16),

// زر تسجيل الدخول
ElevatedButton(
onPressed: _isLoading ? null : _login,
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: _isLoading
? const CircularProgressIndicator(color: Colors.white)
: const Text(
'تسجيل الدخول',
style: TextStyle(fontSize: 18),
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