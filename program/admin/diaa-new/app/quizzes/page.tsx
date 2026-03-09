// ============================================================
// File: quizzes/page.tsx
// Purpose: صفحة قائمة الاختبارات والأسئلة - عرض وتصفية الأسئلة
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import QuizTable from '@/components/quizzes/QuizTable';
// import Button from '@/components/ui/Button';
// import { getQuizzes } from '@/services/quizzes';
// import { Quiz } from '@/types/quiz';
// import { PlusCircle } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: إنشاء state variables
//   - quizzes: Quiz[] (قائمة الأسئلة)
//   - loading: boolean
//   - quizTypeFilter: string (تصفية حسب النوع: 'all' | 'reading' | 'writing' | 'comprehension')

// Step 2: جلب الأسئلة عند تحميل الصفحة
//   - useEffect → getQuizzes({ quiz_type: quizTypeFilter })
//   - الأسئلة مُجمّعة حسب الدرس (grouped by lesson)

// Step 3: بناء شريط التصفية
//   - <select> لنوع الاختبار:
//     - الكل
//     - قراءة (reading)
//     - كتابة (writing)
//     - فهم المقروء (comprehension)
//   - <Button onClick={() => router.push('/quizzes/new')}>إضافة سؤال</Button>

// Step 4: عرض جدول الأسئلة
//   - <QuizTable quizzes={quizzes} onRefresh={fetchQuizzes} />
//   - الأعمدة: نص السؤال (مقتطع)، النوع (Badge)، اسم الدرس، الإجراءات

// Step 5: حالة فارغة
//   - لا توجد أسئلة: "لا توجد أسئلة بعد. أضف سؤالاً جديداً."

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - نوع الاختبار يُعرض كـ Badge ملون (reading=أزرق، writing=أخضر، comprehension=بنفسجي)
// - يمكن تجميع الأسئلة حسب الدرس في العرض (اختياري)
// - إضافة سؤال في صفحة منفصلة /quizzes/new
