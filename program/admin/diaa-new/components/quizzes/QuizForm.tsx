// ============================================================
// File: QuizForm.tsx
// Purpose: نموذج إنشاء/تعديل سؤال اختبار مع خيارات ديناميكية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useForm, useFieldArray } from 'react-hook-form';
// import Input from '@/components/ui/Input';
// import Button from '@/components/ui/Button';
// import { QuizCreateRequest } from '@/types/quiz';
// import { Lesson } from '@/types/lesson';
// import { getLessons } from '@/services/lessons';
// import { PlusCircle, MinusCircle } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface QuizFormProps {
//       initialData?: Quiz;
//       onSubmit: (data: QuizCreateRequest) => Promise<void>;
//     }

// Step 2: إعداد React Hook Form مع useFieldArray للخيارات الديناميكية
//   - const { register, handleSubmit, control, watch, formState: { errors, isSubmitting } } = useForm({
//       defaultValues: initialData || {
//         lesson_id: '', quiz_type: 'reading', question_text: '',
//         options: [{ value: '' }, { value: '' }, { value: '' }],  // 3 خيارات مبدئية
//         correct_answer: '',
//       }
//     });
//   - const { fields, append, remove } = useFieldArray({ control, name: 'options' });
//   - const watchedOptions = watch('options');  // مراقبة الخيارات لتحديث قائمة الإجابة الصحيحة

// Step 3: جلب قائمة الدروس لـ dropdown
//   - const [lessons, setLessons] = useState<Lesson[]>([]);
//   - useEffect → getLessons() → setLessons(response)

// Step 4: بناء حقول النموذج
//   - حقل الدرس (dropdown):
//     <select {...register('lesson_id', { required: 'اختر الدرس' })}>
//       <option value="">اختر الدرس</option>
//       {lessons.map(l => <option key={l.id} value={l.id}>{l.title}</option>)}
//     </select>
//   - حقل نوع الاختبار:
//     <select {...register('quiz_type', { required: true })}>
//       <option value="reading">قراءة</option>
//       <option value="writing">كتابة</option>
//       <option value="comprehension">فهم المقروء</option>
//     </select>
//   - حقل نص السؤال:
//     <textarea {...register('question_text', { required: 'نص السؤال مطلوب' })}
//       className="w-full h-24 p-4 border rounded-lg"
//       placeholder="أدخل نص السؤال..."
//     />

// Step 5: الخيارات الديناميكية (add/remove)
//   - عرض كل خيار: fields.map((field, index) => (
//       <div key={field.id} className="flex items-center gap-2">
//         <Input {...register(`options.${index}.value`, { required: 'الخيار مطلوب' })} placeholder={`الخيار ${index + 1}`} />
//         {fields.length > 3 && <button onClick={() => remove(index)}><MinusCircle /></button>}
//       </div>
//     ))
//   - زر إضافة خيار: {fields.length < 4 && <Button variant="secondary" onClick={() => append({ value: '' })}>إضافة خيار <PlusCircle /></Button>}
//   - القيود: حد أدنى 3، حد أقصى 4 خيارات

// Step 6: حقل الإجابة الصحيحة (select من الخيارات المُدخلة)
//   - <select {...register('correct_answer', { required: 'اختر الإجابة الصحيحة' })}>
//       <option value="">اختر الإجابة الصحيحة</option>
//       {watchedOptions.map((opt, i) => opt.value && <option key={i} value={opt.value}>{opt.value}</option>)}
//     </select>

// Step 7: زر الإرسال
//   - <Button type="submit" isLoading={isSubmitting}>حفظ السؤال</Button>

// --- Notes ---
// - useFieldArray من React Hook Form يدير الخيارات الديناميكية
// - الإجابة الصحيحة يجب أن تكون أحد الخيارات المُدخلة — watch يراقب التغييرات
// - حد أدنى 3 خيارات: لا يمكن حذف أقل من 3
// - حد أقصى 4 خيارات: يختفي زر الإضافة عند 4
// - قائمة الدروس تُجلب عند تحميل النموذج
// - تأكد من تحويل options array إلى string[] قبل الإرسال للـ API
