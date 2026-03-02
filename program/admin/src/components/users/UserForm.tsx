// ============================================================
// File: UserForm.tsx
// Purpose: نموذج إنشاء/تعديل بيانات المستخدم
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useForm } from 'react-hook-form';
// import Input from '@/components/ui/Input';
// import Button from '@/components/ui/Button';
// import { User, UserCreateRequest, UserUpdateRequest } from '@/types/user';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface UserFormProps {
//       initialData?: User;           // بيانات مبدئية (في وضع التعديل)
//       onSubmit: (data: UserCreateRequest | UserUpdateRequest) => Promise<void>;
//       isEditing?: boolean;          // هل نحن في وضع التعديل؟
//     }

// Step 2: إعداد React Hook Form
//   - const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm({
//       defaultValues: initialData ? {
//         name: initialData.name,
//         email: initialData.email,
//         phone: initialData.phone,
//         role: initialData.role,
//         is_active: initialData.is_active,
//       } : { name: '', email: '', phone: '', role: 'student', is_active: true }
//     });

// Step 3: بناء حقول النموذج
//   - حقل الاسم:
//     <Input label="الاسم الكامل" {...register('name', { required: 'الاسم مطلوب' })} error={errors.name?.message} />
//   - حقل البريد الإلكتروني:
//     <Input label="البريد الإلكتروني" type="email" {...register('email', { required: 'البريد مطلوب', pattern: { value: /email regex/, message: 'بريد غير صالح' } })} />
//   - حقل الهاتف:
//     <Input label="رقم الهاتف" {...register('phone')} />
//   - حقل الدور:
//     <select {...register('role', { required: true })}>
//       <option value="student">طالب</option>
//       <option value="parent">ولي أمر</option>
//       <option value="admin">مسؤول</option>
//     </select>
//   - حقل الحالة:
//     <label><input type="checkbox" {...register('is_active')} /> نشط</label>

// Step 4: تخطيط النموذج
//   - <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
//   - حقلين في صف واحد: grid grid-cols-1 md:grid-cols-2 gap-4
//   - الاسم والبريد في صف، الهاتف والدور في صف

// Step 5: زر الإرسال
//   - <Button type="submit" isLoading={isSubmitting}>
//       {isEditing ? 'حفظ التعديلات' : 'إنشاء المستخدم'}
//     </Button>

// --- Notes ---
// - النموذج يُستخدم في وضعين: إنشاء (UserForm بدون initialData) وتعديل (مع initialData)
// - React Hook Form يدير الـ validation و state تلقائياً
// - register يُمرر لكل Input عبر spread operator
// - errors تُعرض تحت كل حقل باللون الأحمر
// - في وضع التعديل: البريد قد يكون غير قابل للتعديل (disabled)
// - isSubmitting يُعطل الزر أثناء الإرسال لمنع الإرسال المتكرر
