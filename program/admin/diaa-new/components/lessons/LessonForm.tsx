// ============================================================
// File: LessonForm.tsx
// Purpose: نموذج إنشاء/تعديل الدروس التعليمية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useForm } from 'react-hook-form';
// import Input from '@/components/ui/Input';
// import Button from '@/components/ui/Button';
// import { Lesson, LessonCreateRequest, LessonUpdateRequest } from '@/types/lesson';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface LessonFormProps {
//       initialData?: Lesson;
//       onSubmit: (data: LessonCreateRequest | LessonUpdateRequest) => Promise<void>;
//       isEditing?: boolean;
//     }

// Step 2: إعداد React Hook Form
//   - const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm({
//       defaultValues: initialData || {
//         title: '', subject: '', grade_level: '', original_text: '', qr_code: ''
//       }
//     });

// Step 3: بناء حقول النموذج
//   - حقل العنوان:
//     <Input label="عنوان الدرس" {...register('title', { required: 'العنوان مطلوب' })} error={errors.title?.message} />
//   - حقل المادة (select):
//     <select {...register('subject', { required: 'المادة مطلوبة' })}>
//       <option value="">اختر المادة</option>
//       <option value="لغتي">لغتي</option>
//       <option value="رياضيات">رياضيات</option>
//       <option value="علوم">علوم</option>
//       <option value="اجتماعيات">اجتماعيات</option>
//       <option value="تربية إسلامية">تربية إسلامية</option>
//     </select>
//   - حقل المرحلة الدراسية (select):
//     <select {...register('grade_level', { required: 'المرحلة مطلوبة' })}>
//       <option value="">اختر المرحلة</option>
//       <option value="الأول">الصف الأول</option>
//       <option value="الثاني">الصف الثاني</option>
//       ... حتى السادس
//     </select>
//   - حقل النص الأصلي (textarea — كبير):
//     <textarea {...register('original_text', { required: 'النص مطلوب' })}
//       className="w-full h-48 p-4 border rounded-lg resize-y"
//       placeholder="أدخل النص الأصلي للدرس..."
//     />
//   - حقل رمز QR:
//     <Input label="رمز QR" {...register('qr_code')} />

// Step 4: تخطيط النموذج
//   - <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
//   - العنوان في صف كامل
//   - المادة والمرحلة في صف واحد: grid grid-cols-2 gap-4
//   - النص الأصلي في صف كامل (textarea كبير)
//   - QR في صف كامل

// Step 5: زر الإرسال
//   - <Button type="submit" isLoading={isSubmitting}>
//       {isEditing ? 'حفظ التعديلات' : 'إنشاء الدرس'}
//     </Button>

// --- Notes ---
// - textarea يحتاج أن يكون كبيراً لأن النص الأصلي قد يكون طويلاً
// - المواد والمراحل ثابتة حالياً — يمكن جلبها من API مستقبلاً
// - QR code يُولد عادة من الباك اند — هذا الحقل اختياري
// - تأكد من validation لجميع الحقول المطلوبة
// - في وضع التعديل: original_text يُعبأ بالنص الحالي
