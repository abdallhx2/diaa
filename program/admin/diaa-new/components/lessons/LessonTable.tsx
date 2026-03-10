// ============================================================
// File: LessonTable.tsx
// Purpose: جدول عرض الدروس مع الإجراءات
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useRouter } from 'next/navigation';
// import Table from '@/components/ui/Table';
// import Button from '@/components/ui/Button';
// import { Lesson } from '@/types/lesson';
// import { Edit, Trash2 } from 'lucide-react';
// import { format } from 'date-fns';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface LessonTableProps {
//       lessons: Lesson[];
//       onDelete?: (id: string) => void;
//       onRefresh?: () => void;
//     }

// Step 2: تعريف أعمدة الجدول
//   - الأعمدة:
//     a) title — عنوان الدرس
//     b) subject — المادة (لغتي، رياضيات، علوم...)
//     c) grade_level — المرحلة الدراسية (الأول، الثاني... السادس)
//     d) qr_code — رمز QR (عرض كنص أو أيقونة رابط)
//     e) created_at — تاريخ الإنشاء: format(date, 'dd/MM/yyyy')
//     f) actions — أزرار: تعديل + حذف

// Step 3: عرض الجدول
//   - <Table columns={columns} data={lessons} onRowClick={(lesson) => router.push(`/lessons/${lesson.id}`)} />

// Step 4: معالجة الإجراءات
//   - زر التعديل: router.push(`/lessons/${lesson.id}`)
//   - زر الحذف: onDelete(lesson.id) — مع تأكيد

// --- Notes ---
// - استخدم Table component الموحد
// - النقر على الصف يوجه لصفحة تعديل الدرس
// - e.stopPropagation() على أزرار الإجراءات
// - يمكن إضافة QR code preview عند hover مستقبلاً
// - المادة والمرحلة يمكن عرضها كـ Badge ملون
