import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class RoleSelectionScreen extends StatelessWidget {
const RoleSelectionScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [

// الشعار
const Icon(
Icons.menu_book,
size: 80,
color: Color(0xFF4A1A7A),
),
const Text(
'ضياء',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 36,
fontWeight: FontWeight.bold,
color: Color(0xFF4A1A7A),
),
),
const Text(
'رفيق التعلم الذكي',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 16,
color: Colors.grey,
),
),

const SizedBox(height: 48),

// العنوان
const Text(
'من أنت؟',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 32),

// Step 3: بطاقة طالب
_buildRoleCard(
context: context,
icon: Icons.school,
title: 'طالب',
description: 'تعلم واستكشف دروسك',
color: const Color(0xFF4A1A7A),
onTap: () =>
Navigator.pushNamed(context, AppRoutes.studentLogin),
),

const SizedBox(height: 16),

// Step 4: بطاقة ولي أمر
_buildRoleCard(
context: context,
icon: Icons.family_restroom,
title: 'ولي أمر',
description: 'تابع تقدم طفلك',
color: Colors.green,
onTap: () =>
Navigator.pushNamed(context, AppRoutes.parentLogin),
),
],
),
),
),
);
}

// Step 5: بناء البطاقة
Widget _buildRoleCard({
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
padding: const EdgeInsets.all(24),
child: Row(
textDirection: TextDirection.rtl,
children: [
// الأيقونة
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: color.withOpacity(0.15),
borderRadius: BorderRadius.circular(16),
),
child: Icon(icon, size: 64, color: color),
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
fontSize: 24,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.right,
),
const SizedBox(height: 4),
Text(
description,
style: const TextStyle(
fontSize: 16,
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