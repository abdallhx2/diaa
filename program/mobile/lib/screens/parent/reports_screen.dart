// ============================================================
// File: reports_screen.dart
// Purpose: شاشة التقارير التفصيلية — رسوم بيانية وقائمة نشاطات
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2-3 — شاشات ولي الأمر والتقارير
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:edu_smart_assistant/providers/parent_provider.dart';
// import 'package:edu_smart_assistant/widgets/report_card_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم ReportsScreen
//         - class ReportsScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات
//         - String _selectedPeriod = 'weekly';  // أسبوعي أو شهري

// Step 3: بناء الواجهة
//         - Scaffold مع AppBar: "التقارير"
//         - Column([
//             // التبديل بين أسبوعي/شهري
//             _buildPeriodToggle(),
//             // الرسوم البيانية
//             _buildCharts(),
//             // قائمة النشاطات التفصيلية
//             _buildActivityList(),
//           ])

// Step 4: إنشاء method _buildPeriodToggle()
//         - ToggleButtons أو SegmentedButton:
//           * "أسبوعي" / "شهري"
//           * عند التبديل: تحميل التقرير المناسب من ParentProvider

// Step 5: إنشاء method _buildCharts()
//         - // رسم بياني 1: درجات الاختبارات (Bar Chart)
//           Container(
//             height: 200,
//             child: BarChart(
//               BarChartData(
//                 barGroups: [...],  // درجات كل اختبار
//                 titlesData: FlTitlesData(...),  // أسماء الاختبارات
//               ),
//             ),
//           )
//         - // رسم بياني 2: التقدم عبر الزمن (Line Chart)
//           Container(
//             height: 200,
//             child: LineChart(
//               LineChartData(
//                 lineBarsData: [...],  // نقاط التقدم
//                 titlesData: FlTitlesData(...),  // التواريخ
//               ),
//             ),
//           )

// Step 6: إنشاء method _buildActivityList()
//         - Text('تفاصيل النشاطات', style: headline)
//         - ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: activities.length,
//             itemBuilder: (_, index) {
//               final activity = activities[index];
//               return ListTile(
//                 leading: Icon(activityIcon),
//                 title: Text(activity['lesson_name']),
//                 subtitle: Text('${activity['quiz_type']} — ${activity['score']}%'),
//                 trailing: Text(activity['date']),
//               );
//             },
//           )

// --- Notes ---
// - استخدام حزمة fl_chart للرسوم البيانية
// - Bar Chart: يعرض درجات الاختبارات (محور X = الاختبارات، Y = الدرجات)
// - Line Chart: يعرض تقدم الطفل عبر الوقت
// - التبديل بين الفترات يُحدث البيانات من ParentProvider
// - ألوان الرسوم البيانية باستيل ومتناسقة مع الثيم
// - قائمة النشاطات تعرض: اسم الدرس، نوع الاختبار، الدرجة، التاريخ
