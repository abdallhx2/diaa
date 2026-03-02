// ============================================================
// File: layout.tsx
// Purpose: الـ Root Layout الرئيسي لتطبيق لوحة التحكم - يغلف كل الصفحات
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// import type { Metadata } from 'next';
// import { Cairo } from 'next/font/google';  // أو استخدم Google Fonts CDN في <head>
// import './globals.css';                     // ملف Tailwind CSS الرئيسي
// import { AuthProvider } from '@/context/AuthProvider';  // سياق المصادقة

// --- Implementation Steps ---
// Step 1: تعريف خط Cairo العربي باستخدام next/font/google
//   - const cairo = Cairo({ subsets: ['arabic'], weight: ['400', '600', '700'] });

// Step 2: تعريف metadata للصفحة
//   - export const metadata: Metadata = {
//       title: 'Edu Smart - لوحة التحكم',
//       description: 'لوحة تحكم المسؤول لنظام Edu Smart التعليمي',
//     };

// Step 3: إنشاء RootLayout component
//   - export default function RootLayout({ children }: { children: React.ReactNode })

// Step 4: إعداد HTML tag بالاتجاه العربي
//   - <html lang="ar" dir="rtl">

// Step 5: تطبيق خط Cairo على body
//   - <body className={cairo.className}>

// Step 6: لف children بـ AuthProvider
//   - <AuthProvider>{children}</AuthProvider>

// --- Notes ---
// - dir="rtl" ضروري لدعم الواجهة العربية من اليمين لليسار
// - AuthProvider يجب أن يكون Client Component (يحتاج 'use client')
// - globals.css يجب أن يحتوي على @tailwind base, components, utilities
// - الخط Cairo يدعم العربية بشكل ممتاز ومتوفر في Google Fonts
