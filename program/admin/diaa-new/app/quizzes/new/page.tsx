// ============================================================
// File: quizzes/new/page.tsx
// Purpose: صفحة إضافة سؤال اختبار جديد
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import QuizForm from '@/components/quizzes/QuizForm';
// import { createQuiz } from '@/services/quizzes';
// import { QuizCreateRequest } from '@/types/quiz';
// import { toast } from 'sonner';

// --- Implementation Steps ---
// Step 1: إنشاء الصفحة مع DashboardLayout
//   - عنوان الصفحة: "إضافة سؤال جديد"

// Step 2: عرض نموذج السؤال
//   - <QuizForm onSubmit={handleCreate} />
//   - النموذج يشمل: اختيار الدرس، نوع السؤال، نص السؤال، الخيارات، الإجابة الصحيحة

// Step 3: معالجة إرسال النموذج (handleCreate)
//   - async function handleCreate(data: QuizCreateRequest)
//   - createQuiz(data) → POST /api/admin/quizzes (أو /api/quizzes)
//   - عند النجاح: toast.success('تم إضافة السؤال بنجاح')
//   - عند النجاح: router.push('/quizzes')
//   - عند الخطأ: toast.error('حدث خطأ أثناء إضافة السؤال')

// Step 4: زر العودة
//   - رابط "← العودة للأسئلة" في أعلى الصفحة

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - QuizForm يحتاج قائمة الدروس لعرضها في dropdown (يجلبها داخلياً أو يستقبلها كـ prop)
// - الخيارات ديناميكية: حد أدنى 3 وحد أقصى 4 خيارات
// - الإجابة الصحيحة يجب أن تكون أحد الخيارات المُدخلة
