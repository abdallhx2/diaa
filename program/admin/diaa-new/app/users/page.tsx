// ============================================================
// File: users/page.tsx
// Purpose: صفحة قائمة المستخدمين - عرض وبحث وتصفية المستخدمين
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import UserTable from '@/components/users/UserTable';
// import Button from '@/components/ui/Button';
// import Input from '@/components/ui/Input';
// import Modal from '@/components/ui/Modal';
// import UserForm from '@/components/users/UserForm';
// import { getUsers, createUser } from '@/services/users';
// import { User } from '@/types/user';
// import { UserPlus, Search } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: إنشاء state variables
//   - users: User[] (قائمة المستخدمين)
//   - loading: boolean
//   - searchQuery: string (نص البحث)
//   - roleFilter: string (تصفية حسب الدور: 'all' | 'student' | 'parent' | 'admin')
//   - isModalOpen: boolean (نافذة إضافة مستخدم)
//   - currentPage: number (الصفحة الحالية)
//   - totalPages: number

// Step 2: جلب المستخدمين عند تحميل الصفحة أو تغيير الفلاتر
//   - useEffect → getUsers({ search: searchQuery, role: roleFilter, page: currentPage })
//   - تحديث users و totalPages من الاستجابة
//   - dependencies: [searchQuery, roleFilter, currentPage]

// Step 3: بناء شريط البحث والتصفية
//   - <Input placeholder="البحث بالاسم..." /> مع أيقونة Search
//   - <select> لتصفية الأدوار: الكل، طالب، ولي أمر، مسؤول
//   - <Button onClick={() => setIsModalOpen(true)}>إضافة مستخدم</Button> مع أيقونة UserPlus
//   - تخطيط: flex justify-between items-center gap-4 mb-6

// Step 4: عرض جدول المستخدمين
//   - <UserTable users={filteredUsers} onRefresh={fetchUsers} />
//   - تمرير البيانات المُصفاة للجدول

// Step 5: ترقيم الصفحات (Pagination)
//   - 10 مستخدمين لكل صفحة
//   - أزرار: السابق، أرقام الصفحات، التالي
//   - تحديث currentPage عند النقر

// Step 6: نافذة إضافة مستخدم جديد (Modal)
//   - <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title="إضافة مستخدم جديد">
//   - <UserForm onSubmit={handleCreateUser} />
//   - handleCreateUser: createUser(data) → أغلق Modal → أعد جلب المستخدمين

// --- Notes ---
// - لف المحتوى بـ <DashboardLayout>
// - استخدم debounce للبحث (تأخير 300ms) لتقليل الطلبات
// - UserForm يُستخدم لكل من الإنشاء والتعديل (نفس النموذج)
// - عند إضافة مستخدم بنجاح، أظهر toast نجاح باستخدام sonner
