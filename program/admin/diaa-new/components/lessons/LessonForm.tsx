// ============================================================
// File: LessonForm.tsx
// Purpose: نموذج إنشاء/تعديل الدروس التعليمية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useForm } from 'react-hook-form';
import Input from '@/components/ui/Input';
import Button from '@/components/ui/Button';
import { Lesson, LessonCreateRequest, LessonUpdateRequest } from '@/types/lesson';

// Step 2: تعريف Props
interface LessonFormProps {
  initialData?: Lesson;
  onSubmit: (data: LessonCreateRequest | LessonUpdateRequest) => Promise<void>;
  isEditing?: boolean;
}

// Step 3 + 4 + 5: بناء المكون
export default function LessonForm({ initialData, onSubmit, isEditing = false }: LessonFormProps) {

  // Step 3: إعداد React Hook Form
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm({
    defaultValues: initialData || {
      title: '',
      subject: '',
      grade_level: '',
      original_text: '',
      qr_code: '',
    },
  });

  return (
    // Step 4: تخطيط النموذج
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">

      {/* حقل العنوان */}
      <Input
        label="عنوان الدرس"
        {...register('title', { required: 'العنوان مطلوب' })}
        error={errors.title?.message}
        placeholder="أدخل عنوان الدرس..."
      />

      {/* المادة والمرحلة في صف واحد */}
      <div className="grid grid-cols-2 gap-4">

        {/* حقل المادة */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">المادة</label>
          <select
            {...register('subject', { required: 'المادة مطلوبة' })}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="">اختر المادة</option>
            <option value="لغتي">لغتي</option>
            <option value="رياضيات">رياضيات</option>
            <option value="علوم">علوم</option>
            <option value="اجتماعيات">اجتماعيات</option>
            <option value="تربية إسلامية">تربية إسلامية</option>
          </select>
          {errors.subject && <p className="mt-1 text-sm text-red-500">{errors.subject.message}</p>}
        </div>

        {/* حقل المرحلة */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">المرحلة الدراسية</label>
          <select
            {...register('grade_level', { required: 'المرحلة مطلوبة' })}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="">اختر المرحلة</option>
            <option value="الأول">الصف الأول</option>
            <option value="الثاني">الصف الثاني</option>
            <option value="الثالث">الصف الثالث</option>
            <option value="الرابع">الصف الرابع</option>
            <option value="الخامس">الصف الخامس</option>
            <option value="السادس">الصف السادس</option>
          </select>
          {errors.grade_level && <p className="mt-1 text-sm text-red-500">{errors.grade_level.message}</p>}
        </div>

      </div>

      {/* حقل النص الأصلي */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">النص الأصلي</label>
        <textarea
          {...register('original_text', { required: 'النص مطلوب' })}
          className="w-full h-48 p-4 border border-gray-300 rounded-lg resize-y text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
          placeholder="أدخل النص الأصلي للدرس..."
        />
        {errors.original_text && <p className="mt-1 text-sm text-red-500">{errors.original_text.message}</p>}
      </div>

      {/* حقل QR */}
      <Input
        label="رمز QR"
        {...register('qr_code')}
        placeholder="رمز QR (اختياري)"
      />

      {/* Step 5: زر الإرسال */}
      <Button type="submit" isLoading={isSubmitting} className="w-full">
        {isEditing ? 'حفظ التعديلات' : 'إنشاء الدرس'}
      </Button>

    </form>
  );
}
