// ============================================================
// File: UserTable.tsx
// Purpose: جدول عرض المستخدمين مع الفرز والإجراءات
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useRouter } from 'next/navigation';
// import { useReactTable, getCoreRowModel, getSortedRowModel, createColumnHelper, flexRender } from '@tanstack/react-table';
// import Table from '@/components/ui/Table';
// import Badge from '@/components/ui/Badge';
// import Button from '@/components/ui/Button';
// import { User } from '@/types/user';
// import { Edit, Trash2 } from 'lucide-react';
// import { format } from 'date-fns';
// import { ar } from 'date-fns/locale';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface UserTableProps {
//       users: User[];
//       onDelete?: (id: string) => void;
//       onRefresh?: () => void;
//     }

// Step 2: تعريف أعمدة الجدول باستخدام TanStack Table
//   - const columnHelper = createColumnHelper<User>();
//   - الأعمدة:
//     a) checkbox — لتحديد الصفوف (اختياري)
//     b) name — اسم المستخدم (نص)
//     c) role — الدور: استخدم <Badge>
//        - admin → variant="info" text="مسؤول"
//        - student → variant="success" text="طالب"
//        - parent → variant="warning" text="ولي أمر"
//     d) email — البريد الإلكتروني
//     e) phone — رقم الهاتف (اختياري)
//     f) status — الحالة: <Badge variant={is_active ? 'success' : 'danger'} text={is_active ? 'نشط' : 'معطل'} />
//     g) created_at — تاريخ الإنشاء: format(date, 'dd/MM/yyyy')
//     h) actions — أزرار: تعديل (Edit icon) + حذف (Trash2 icon)

// Step 3: إعداد TanStack Table instance
//   - const table = useReactTable({
//       data: users,
//       columns,
//       getCoreRowModel: getCoreRowModel(),
//       getSortedRowModel: getSortedRowModel(),
//     });

// Step 4: عرض الجدول
//   - استخدم Table component أو اعرض يدوياً
//   - <thead>: أعمدة مع إمكانية الفرز (onClick → toggleSorting)
//   - <tbody>: صفوف البيانات
//   - عند النقر على صف → router.push(`/users/${user.id}`)

// Step 5: معالجة الإجراءات
//   - زر التعديل: router.push(`/users/${user.id}`)
//   - زر الحذف: onDelete(user.id) — يجب تأكيد من الصفحة الأم

// --- Notes ---
// - TanStack Table يوفر sorting, filtering, pagination جاهزة
// - Badge يُستخدم لعرض الأدوار والحالات بألوان مختلفة
// - تأكد من أن النقر على أزرار الإجراءات لا يُفعّل onRowClick
//   - استخدم e.stopPropagation() على أزرار الإجراءات
// - الجدول يجب أن يكون responsive — أخفِ بعض الأعمدة في الموبايل
// - hover effect: hover:bg-gray-50 على الصفوف
