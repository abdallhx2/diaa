// ============================================================
// File: lessons/[id]/page.tsx
// Purpose: صفحة عرض وتعديل درس محدد
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useParams, useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import LessonForm from '@/components/lessons/LessonForm';
// import Button from '@/components/ui/Button';
// import Modal from '@/components/ui/Modal';
// import { getLessonById, updateLesson, deleteLesson } from '@/services/lessons';
// import { Lesson } from '@/types/lesson';
// import { Trash2 } from 'lucide-react';
// import { toast } from 'sonner';

// --- Implementation Steps ---
// Step 1: الحصول على معرف الدرس من URL params
//   - const params = useParams();
//   - const lessonId = params.id as string;

// Step 2: إنشاء state variables
//   - lesson: Lesson | null
//   - loading: boolean
//   - isDeleteModalOpen: boolean

// Step 3: جلب بيانات الدرس عند تحميل الصفحة
//   - useEffect → getLessonById(lessonId)
//   - تعبئة lesson من الاستجابة

// Step 4: عرض نموذج التعديل مُعبأ بالبيانات
//   - <LessonForm initialData={lesson} onSubmit={handleUpdate} isEditing={true} />

// Step 5: معالجة حفظ التعديلات (handleUpdate)
//   - updateLesson(lessonId, data) → PUT /api/admin/lessons/{id}
//   - عند النجاح: toast.success('تم تحديث الدرس بنجاح')
//   - عند الخطأ: toast.error('حدث خطأ أثناء التحديث')

// Step 6: زر الحذف مع نافذة التأكيد
//   - <Button variant="danger">حذف الدرس</Button>
//   - Modal: "هل أنت متأكد من حذف هذا الدرس؟"
//   - تأكيد → deleteLesson(lessonId) → router.push('/lessons')

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - عند حذف درس، تُحذف أيضاً الأسئلة المرتبطة به (من الباك اند)
// - أضف زر عودة للقائمة في أعلى الصفحة
// - Loading skeleton أثناء جلب البيانات
