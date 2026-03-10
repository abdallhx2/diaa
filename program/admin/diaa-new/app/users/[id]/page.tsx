// ============================================================
// File: users/[id]/page.tsx
// Purpose: صفحة عرض وتعديل بيانات مستخدم محدد
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useParams, useRouter } from 'next/navigation';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import UserForm from '@/components/users/UserForm';
// import Button from '@/components/ui/Button';
// import Modal from '@/components/ui/Modal';
// import { getUserById, updateUser, deleteUser } from '@/services/users';
// import { User } from '@/types/user';
// import { ArrowRight, Trash2 } from 'lucide-react';
// import { toast } from 'sonner';

// --- Implementation Steps ---
// Step 1: الحصول على معرف المستخدم من URL params
//   - const params = useParams();
//   - const userId = params.id as string;

// Step 2: إنشاء state variables
//   - user: User | null (بيانات المستخدم)
//   - loading: boolean
//   - isDeleteModalOpen: boolean (نافذة تأكيد الحذف)

// Step 3: جلب بيانات المستخدم عند تحميل الصفحة
//   - useEffect → getUserById(userId)
//   - تعبئة user من الاستجابة
//   - إذا لم يُوجد المستخدم: عرض "المستخدم غير موجود" أو redirect

// Step 4: عرض نموذج التعديل
//   - <UserForm initialData={user} onSubmit={handleUpdate} isEditing={true} />
//   - النموذج مُعبأ مسبقاً ببيانات المستخدم
//   - الحقول: name, email, phone, role, is_active

// Step 5: معالجة حفظ التعديلات (handleUpdate)
//   - updateUser(userId, data) → PUT /api/admin/users/{id}
//   - عند النجاح: toast.success('تم تحديث بيانات المستخدم بنجاح')
//   - عند الخطأ: toast.error('حدث خطأ أثناء التحديث')

// Step 6: زر الحذف مع نافذة التأكيد
//   - <Button variant="danger" onClick={() => setIsDeleteModalOpen(true)}>حذف المستخدم</Button>
//   - <Modal title="تأكيد الحذف">
//     - "هل أنت متأكد من حذف هذا المستخدم؟ لا يمكن التراجع عن هذا الإجراء."
//     - زر تأكيد → deleteUser(userId) → router.push('/users')
//     - زر إلغاء → أغلق Modal

// Step 7: زر العودة لقائمة المستخدمين
//   - <Button variant="secondary" onClick={() => router.push('/users')}>
//   - <ArrowRight /> العودة للمستخدمين  (ArrowRight لأن الاتجاه RTL)

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - استخدم Loading skeleton أثناء جلب البيانات
// - ArrowRight تظهر كسهم يسار في RTL (وهو المطلوب للعودة)
// - تأكد من تأكيد الحذف قبل تنفيذه — عملية لا رجعة فيها
// - يمكن إضافة عرض نشاطات المستخدم في تبويب منفصل (مستقبلي)
