// ============================================================
// File: lessons/page.tsx
// Purpose: صفحة قائمة الدروس - عرض وبحث وتصفية الدروس التعليمية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import LessonTable from '@/components/lessons/LessonTable';
// import Button from '@/components/ui/Button';
// import Input from '@/components/ui/Input';
// import { getLessons } from '@/services/lessons';
// import { Lesson } from '@/types/lesson';
// import { PlusCircle, Search } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: إنشاء state variables
//   - lessons: Lesson[] (قائمة الدروس)
//   - loading: boolean
//   - searchQuery: string (البحث بالعنوان)
//   - subjectFilter: string (تصفية حسب المادة)
//   - gradeFilter: string (تصفية حسب المرحلة الدراسية)

// Step 2: جلب الدروس عند تحميل الصفحة
//   - useEffect → getLessons({ search: searchQuery, subject: subjectFilter, grade: gradeFilter })
//   - تحديث lessons من الاستجابة

// Step 3: بناء شريط البحث والتصفية
//   - <Input placeholder="البحث بعنوان الدرس..." /> مع أيقونة Search
//   - <select> للمادة: الكل، لغتي، رياضيات، علوم ...
//   - <select> للمرحلة: الكل، الأول، الثاني، ... السادس
//   - <Button onClick={() => router.push('/lessons/new')}>إضافة درس جديد</Button>

// Step 4: عرض جدول الدروس
//   - <LessonTable lessons={lessons} onRefresh={fetchLessons} />
//   - الأعمدة: العنوان، المادة، المرحلة، تاريخ الإنشاء، الإجراءات

// Step 5: حالة التحميل والحالة الفارغة
//   - loading: skeleton placeholder
//   - لا توجد دروس: رسالة "لا توجد دروس بعد" مع زر إضافة

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - زر "إضافة درس جديد" يوجه لـ /lessons/new (صفحة منفصلة، ليس Modal)
// - يمكن إضافة pagination لاحقاً إذا زاد عدد الدروس
// - تأكد من أن التصفية تعمل client-side أو server-side حسب حجم البيانات
