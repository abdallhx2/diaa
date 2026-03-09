// ============================================================
// File: lessons/new/page.tsx
// Purpose: صفحة إضافة درس جديد
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import LessonForm from '@/components/lessons/LessonForm';
// import { createLesson } from '@/services/lessons';
// import { LessonCreateRequest } from '@/types/lesson';
// import { toast } from 'sonner';

// --- Implementation Steps ---
// Step 1: إنشاء الصفحة مع DashboardLayout
//   - عنوان الصفحة: "إضافة درس جديد"

// Step 2: عرض نموذج الدرس فارغاً
//   - <LessonForm onSubmit={handleCreate} />
//   - النموذج بدون بيانات مبدئية (وضع الإنشاء)

// Step 3: معالجة إرسال النموذج (handleCreate)
//   - async function handleCreate(data: LessonCreateRequest)
//   - استدعاء createLesson(data) → POST /api/admin/lessons
//   - عند النجاح: toast.success('تم إضافة الدرس بنجاح')
//   - عند النجاح: router.push('/lessons') → العودة لقائمة الدروس
//   - عند الخطأ: toast.error('حدث خطأ أثناء إضافة الدرس')

// Step 4: زر العودة لقائمة الدروس
//   - رابط أو زر في الأعلى: "← العودة للدروس"

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - LessonForm هو نفس المكون المستخدم في الإنشاء والتعديل
// - تأكد من validation قبل الإرسال (يتم في LessonForm)
// - toast من مكتبة sonner لإظهار إشعارات النجاح/الخطأ
