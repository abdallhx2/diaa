// ============================================================
// File: QuizForm.tsx
// Purpose: نموذج إنشاء/تعديل سؤال اختبار مع خيارات ديناميكية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useEffect, useState } from 'react';
import { useForm, useFieldArray } from 'react-hook-form';
import Input from '@/components/ui/Input';
import Button from '@/components/ui/Button';
import { QuizCreateRequest } from '@/types/quiz';
import { Lesson } from '@/types/lesson';
import { getLessons } from '@/services/lessons';
import { PlusCircle, MinusCircle } from 'lucide-react';

// Step 2: تعريف Props
interface QuizFormProps {
  initialData?: any;
  onSubmit: (data: QuizCreateRequest) => Promise<void>;
}

export default function QuizForm({ initialData, onSubmit }: QuizFormProps) {

  // Step 3: إعداد React Hook Form
  const { register, handleSubmit, control, watch, formState: { errors, isSubmitting } } = useForm({
    defaultValues: initialData || {
      lesson_id: '',
      quiz_type: 'reading',
      question_text: '',
      options: [{ value: '' }, { value: '' }, { value: '' }],
      correct_answer: '',
    },
  });

  const { fields, append, remove } = useFieldArray({ control, name: 'options' });
  const watchedOptions = watch('options');

  // Step 4: جلب قائمة الدروس
  const [lessons, setLessons] = useState<Lesson[]>([]);

  useEffect(() => {
    getLessons().then((res) => setLessons(res));
  }, []);

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">

      {/* Step 5: حقل الدرس */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">الدرس</label>
        <select
          {...register('lesson_id', { required: 'اختر الدرس' })}
          className="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
        >
          <option value="">اختر الدرس</option>
          {lessons.map((l) => (
            <option key={l.id} value={l.id}>{l.title}</option>
          ))}
        </select>
        {errors.lesson_id && <p className="mt-1 text-sm text-red-500">{errors.lesson_id.message}</p>}
      </div>

      {/* حقل نوع الاختبار */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">نوع الاختبار</label>
        <select
          {...register('quiz_type', { required: true })}
          className="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
        >
          <option value="reading">قراءة</option>
          <option value="writing">كتابة</option>
          <option value="comprehension">فهم المقروء</option>
        </select>
      </div>

      {/* حقل نص السؤال */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">نص السؤال</label>
        <textarea
          {...register('question_text', { required: 'نص السؤال مطلوب' })}
          className="w-full h-24 p-4 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
          placeholder="أدخل نص السؤال..."
        />
        {errors.question_text && <p className="mt-1 text-sm text-red-500">{errors.question_text.message}</p>}
      </div>

      {/* Step 6: الخيارات الديناميكية */}
      <div className="space-y-3">
        <label className="block text-sm font-medium text-gray-700">الخيارات</label>
        {fields.map((field, index) => (
          <div key={field.id} className="flex items-center gap-2">
            <Input
              {...register(`options.${index}.value`, { required: 'الخيار مطلوب' })}
              placeholder={`الخيار ${index + 1}`}
            />
            {fields.length > 3 && (
              <button type="button" onClick={() => remove(index)} className="text-red-500">
                <MinusCircle className="h-5 w-5" />
              </button>
            )}
          </div>
        ))}
        {fields.length < 4 && (
          <Button
            type="button"
            variant="secondary"
            onClick={() => append({ value: '' })}
          >
            إضافة خيار <PlusCircle className="mr-2 h-4 w-4" />
          </Button>
        )}
      </div>

      {/* Step 7: الإجابة الصحيحة */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">الإجابة الصحيحة</label>
        <select
          {...register('correct_answer', { required: 'اختر الإجابة الصحيحة' })}
          className="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:outline-none focus:ring-2 focus:ring-primary-500"
        >
          <option value="">اختر الإجابة الصحيحة</option>
          {watchedOptions.map((opt: any, i: number) =>
            opt.value && <option key={i} value={opt.value}>{opt.value}</option>
          )}
        </select>
        {errors.correct_answer && <p className="mt-1 text-sm text-red-500">{errors.correct_answer.message}</p>}
      </div>

      {/* Step 8: زر الإرسال */}
      <Button type="submit" isLoading={isSubmitting} className="w-full">
        حفظ السؤال
      </Button>

    </form>
  );
}
