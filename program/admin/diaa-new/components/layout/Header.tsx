// ============================================================
// File: Header.tsx
// Purpose: الشريط العلوي - يعرض عنوان الصفحة ومعلومات المسؤول
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// 'use client';
// import { usePathname } from 'next/navigation';
// import { Bell, LogOut, Menu } from 'lucide-react';
// import { signOut } from '@/services/auth';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface HeaderProps {
//       onMenuToggle?: () => void;  // لزر hamburger في الموبايل
//     }

// Step 2: تحديد عنوان الصفحة ديناميكياً من pathname
//   - const pathname = usePathname();
//   - const pageTitles: Record<string, string> = {
//       '/dashboard': 'لوحة المعلومات',
//       '/users': 'إدارة المستخدمين',
//       '/lessons': 'إدارة الدروس',
//       '/quizzes': 'إدارة الاختبارات',
//       '/logs': 'سجلات النظام',
//       '/settings': 'الإعدادات',
//     };
//   - استخرج العنوان المناسب بناءً على pathname

// Step 3: بناء هيكل Header
//   - <header className="fixed top-0 right-[250px] left-0 h-16 bg-white shadow-sm z-30 flex items-center justify-between px-6">
//   - ثابت في الأعلى، يبدأ بعد Sidebar (right: 250px في RTL)

// Step 4: الجانب الأيمن (RTL) — عنوان الصفحة
//   - <h1 className="text-xl font-bold text-gray-800">{pageTitle}</h1>
//   - زر hamburger للموبايل: <Menu className="lg:hidden" onClick={onMenuToggle} />

// Step 5: الجانب الأيسر (RTL) — معلومات المسؤول
//   - اسم المسؤول: <span className="text-gray-600">مرحباً، المسؤول</span>
//   - أيقونة الإشعارات: <Bell className="text-gray-400 cursor-pointer hover:text-gray-600" />
//   - زر تسجيل الخروج: <LogOut onClick={handleLogout} />

// --- Notes ---
// - Header ثابت (fixed) مع z-30 (أقل من Sidebar z-40)
// - في الموبايل: right يصبح 0 (Sidebar مخفي) ويظهر زر Menu
// - يمكن جلب اسم المسؤول الحقيقي من AuthContext بدل النص الثابت
// - الإشعارات حالياً شكلية — يمكن ربطها بـ API لاحقاً
// - استخدم transition-colors للتأثيرات عند hover
