// ============================================================
// File: QuizTable.tsx
// Purpose: جدول عرض أسئلة الاختبارات
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import Table from '@/components/ui/Table';
// import Badge from '@/components/ui/Badge';
// import Button from '@/components/ui/Button';
// import { Quiz } from '@/types/quiz';
// import { Edit, Trash2 } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface QuizTableProps {
//       quizzes: Quiz[];
//       onEdit?: (id: string) => void;
//       onDelete?: (id: string) => void;
//       onRefresh?: () => void;
//     }

// Step 2: تعريف أعمدة الجدول
//   - الأعمدة:
//     a) question_text — نص السؤال (مقتطع إلى 50 حرف)
//        - عرض: quiz.question_text.substring(0, 50) + (quiz.question_text.length > 50 ? '...' : '')
//     b) quiz_type — نوع الاختبار كـ Badge
//        - reading → <Badge text="قراءة" variant="info" />
//        - writing → <Badge text="كتابة" variant="success" />
//        - comprehension → <Badge text="فهم المقروء" variant="warning" />
//     c) lesson_title — اسم الدرس المرتبط
//     d) options_count — عدد الخيارات: quiz.options.length
//     e) actions — أزرار: تعديل + حذف

// Step 3: عرض الجدول
//   - <Table columns={columns} data={quizzes} />

// Step 4: تجميع حسب الدرس (اختياري)
//   - يمكن تجميع الأسئلة حسب lesson_id وعرض عنوان الدرس كمجموعة
//   - أو عرضها مسطحة مع عمود lesson_title

// --- Notes ---
// - نص السؤال يُقتطع لمنع تمدد الجدول
// - Badge ملون حسب نوع الاختبار لسهولة التمييز البصري
// - أزرار التعديل والحذف في آخر عمود
// - يمكن إضافة tooltip يعرض النص الكامل عند hover على السؤال المقتطع
// - عدد الخيارات يُعطي فكرة سريعة عن السؤال (3 أو 4 خيارات)
