import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class ParentRegisterScreen extends StatefulWidget {
const ParentRegisterScreen({super.key});

@override
State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
// Step 2: المتغيرات
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
final _phoneController = TextEditingController();
bool _isLoading = false;
bool _obscurePassword = true;
bool _obscureConfirm = true;

// Step 4: التسجيل
Future<void> _register() async {
if (!_formKey.currentState!.validate()) return;

setState(() => _isLoading = true);

try {
await context.read<AuthProvider>().registerParent({
'name': _nameController.text.trim(),
'email': _emailController.text.trim(),
'password': _passwordController.text,
'phone': _phoneController.text.trim(),
});

Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);

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

// Step 6: dispose
@override
void dispose() {
_nameController.dispose();
_emailController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();
_phoneController.dispose();
super.dispose();
}

// Step 3: بناء الواجهة
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: const Text('إنشاء حساب جديد'),
backgroundColor: const Color(0xFF4A1A7A),
foregroundColor: Colors.white,
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
size: 60,
color: Color(0xFF4A1A7A),
),
const Text(
'ضياء',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Color(0xFF4A1A7A),
),
),

const SizedBox(height: 24),

// حقل الاسم
TextFormField(
controller: _nameController,
textDirection: TextDirection.rtl,
decoration: InputDecoration(
labelText: 'الاسم الكامل',
hintText: 'أدخل اسمك الكامل',
prefixIcon: const Icon(Icons.person_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Color(0xFF4A1A7A)),
),
),
validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
),

const SizedBox(height: 16),

// حقل البريد
TextFormField(
controller: _emailController,
textDirection: TextDirection.ltr,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'البريد الإلكتروني',
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
v!.length < 6 ? 'يجب 6 أحرف على الأقل' : null,
),

const SizedBox(height: 16),

// حقل تأكيد كلمة المرور
TextFormField(
controller: _confirmPasswordController,
obscureText: _obscureConfirm,
decoration: InputDecoration(
labelText: 'تأكيد كلمة المرور',
prefixIcon: const Icon(Icons.lock_outline),
suffixIcon: IconButton(
icon: Icon(_obscureConfirm
? Icons.visibility_off
: Icons.visibility),
onPressed: () =>
setState(() => _obscureConfirm = !_obscureConfirm),
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Color(0xFF4A1A7A)),
),
),
validator: (v) => v != _passwordController.text
? 'كلمات المرور غير متطابقة'
: null,
),

const SizedBox(height: 16),

// حقل رقم الهاتف
TextFormField(
controller: _phoneController,
textDirection: TextDirection.ltr,
keyboardType: TextInputType.phone,
decoration: InputDecoration(
labelText: 'رقم الهاتف',
prefixIcon: const Icon(Icons.phone_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Color(0xFF4A1A7A)),
),
),
validator: (v) =>
v!.length < 10 ? 'رقم هاتف غير صالح' : null,
),

const SizedBox(height: 24),

// زر التسجيل
ElevatedButton(
onPressed: _isLoading ? null : _register,
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
'إنشاء الحساب',
style: TextStyle(fontSize: 18),
),
),

const SizedBox(height: 12),

// رابط تسجيل الدخول
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text(
'لديك حساب؟ تسجيل دخول',
style: TextStyle(color: Color(0xFF4A1A7A)),
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