// ============================================================
// File: add_child_screen.dart
// Purpose: شاشة إضافة طفل — نموذج إدخال بيانات الطفل الجديد
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2-3 — شاشات ولي الأمر والتقارير
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/parent_provider.dart';
// import 'package:edu_smart_assistant/widgets/custom_text_field.dart';
// import 'package:edu_smart_assistant/widgets/custom_button.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم AddChildScreen
//         - class AddChildScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات
//         - final _formKey = GlobalKey<FormState>();
//         - final _nameController = TextEditingController();
//         - final _ageController = TextEditingController();
//         - String? _selectedGrade;          // الصف المختار
//         - String? _selectedLevel;          // المستوى المختار
//         - bool _isLoading = false;

// Step 3: بناء Form مع الحقول
//         - Scaffold مع AppBar: "إضافة طفل"
//         - Form(key: _formKey, child: ListView([
//             // حقل الاسم
//             CustomTextField(
//               label: 'اسم الطفل',
//               hint: 'أدخل اسم الطفل',
//               controller: _nameController,
//               validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
//               prefixIcon: Icons.person,
//             ),
//             // حقل العمر
//             CustomTextField(
//               label: 'العمر',
//               hint: 'أدخل عمر الطفل',
//               controller: _ageController,
//               keyboardType: TextInputType.number,
//               validator: (v) => v!.isEmpty ? 'العمر مطلوب' : null,
//               prefixIcon: Icons.cake,
//             ),
//             // قائمة الصف الدراسي
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'الصف الدراسي'),
//               items: ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس', 'السادس']
//                 .map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
//               onChanged: (v) => _selectedGrade = v,
//               validator: (v) => v == null ? 'اختر الصف الدراسي' : null,
//             ),
//             // قائمة المستوى التعليمي
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'المستوى التعليمي'),
//               items: ['مبتدئ', 'متوسط', 'متقدم']
//                 .map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
//               onChanged: (v) => _selectedLevel = v,
//               validator: (v) => v == null ? 'اختر المستوى' : null,
//             ),
//             SizedBox(height: 24),
//             // زر الإرسال
//             CustomButton(
//               text: 'إضافة الطفل',
//               isLoading: _isLoading,
//               onPressed: _submitForm,
//             ),
//           ]))

// Step 4: إنشاء method _submitForm()
//         - إذا !_formKey.currentState!.validate(): return
//         - setState(() => _isLoading = true);
//         - data = { name, age, grade, learning_level }
//         - استدعاء context.read<ParentProvider>().addChild(data)
//         - عند النجاح:
//           * عرض SnackBar: "تمت إضافة الطفل بنجاح"
//           * Navigator.pop(context)
//         - عند الفشل:
//           * عرض SnackBar: رسالة الخطأ بالعربي
//         - setState(() => _isLoading = false);

// Step 5: في dispose
//         - _nameController.dispose();
//         - _ageController.dispose();

// --- Notes ---
// - جميع الحقول مطلوبة مع validation بالعربي
// - الصفوف: الأول إلى السادس (ابتدائي)
// - المستويات: مبتدئ / متوسط / متقدم
// - استخدام CustomTextField و CustomButton المخصصة
// - التصميم RTL مع حدود مستديرة وألوان باستيل
