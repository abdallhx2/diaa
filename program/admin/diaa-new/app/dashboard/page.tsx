// ============================================================
// File: dashboard/page.tsx
// Purpose: لوحة المعلومات الرئيسية - عرض الإحصائيات والنشاطات
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import DashboardLayout from '@/components/layout/DashboardLayout';
// import Card from '@/components/ui/Card';
// import api from '@/services/api';
// import { Users, UserCheck, BookOpen, Calendar } from 'lucide-react';  // أيقونات
// import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

// --- Implementation Steps ---
// Step 1: تعريف interfaces للبيانات
//   - DashboardStats { total_users, active_users_7d, sessions_this_week, sessions_this_month }
//   - WeeklyActivity { day: string, sessions: number }
//   - RecentActivity { id, user_name, action, created_at }

// Step 2: إنشاء state variables
//   - stats: DashboardStats | null
//   - weeklyData: WeeklyActivity[]
//   - recentActivities: RecentActivity[]
//   - loading: boolean

// Step 3: جلب البيانات عند تحميل الصفحة
//   - useEffect → GET /api/admin/dashboard
//   - تعبئة stats, weeklyData, recentActivities من الاستجابة

// Step 4: عرض 4 بطاقات إحصائية (stat cards)
//   - بطاقة 1: إجمالي المستخدمين (أيقونة Users) — stats.total_users
//   - بطاقة 2: المستخدمون النشطون (أيقونة UserCheck) — stats.active_users_7d
//   - بطاقة 3: جلسات هذا الأسبوع (أيقونة BookOpen) — stats.sessions_this_week
//   - بطاقة 4: جلسات هذا الشهر (أيقونة Calendar) — stats.sessions_this_month
//   - استخدم grid: grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6

// Step 5: رسم بياني للنشاط الأسبوعي باستخدام Recharts
//   - <Card title="النشاط الأسبوعي">
//   - <ResponsiveContainer width="100%" height={300}>
//   - <BarChart data={weeklyData}>
//   - أعمدة: XAxis=day, Bar=sessions, لون أزرق فاتح

// Step 6: قائمة النشاطات الأخيرة
//   - <Card title="آخر النشاطات">
//   - عرض آخر 10 نشاطات في قائمة
//   - لكل نشاط: اسم المستخدم، الإجراء، التاريخ (مُنسق بـ date-fns)

// Step 7: حالة التحميل (Loading skeleton)
//   - أثناء loading === true، اعرض placeholder متحرك
//   - استخدم animate-pulse مع bg-gray-200 بأحجام البطاقات

// --- Notes ---
// - لف كل المحتوى بـ <DashboardLayout> لضمان Sidebar و Header
// - استخدم date-fns/format لتنسيق التواريخ بالعربي
// - الرسم البياني يحتاج ResponsiveContainer ليكون متجاوب
// - يمكن إضافة تحديث تلقائي كل 5 دقائق (اختياري)
