// ============================================================
// File: DashboardLayout.tsx
// Purpose: الهيكل العام للوحة التحكم - يجمع Sidebar و Header والمحتوى
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useState } from 'react';
// import { useRouter } from 'next/navigation';
// import Sidebar from '@/components/layout/Sidebar';
// import Header from '@/components/layout/Header';
// import { onAuthStateChanged } from '@/services/auth';  // أو من AuthContext

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface DashboardLayoutProps {
//       children: React.ReactNode;
//     }

// Step 2: التحقق من حالة المصادقة
//   - const [isAuthenticated, setIsAuthenticated] = useState(false);
//   - const [loading, setLoading] = useState(true);
//   - useEffect → onAuthStateChanged((user) => {
//       if (!user) router.push('/');  // إعادة توجيه لتسجيل الدخول
//       else setIsAuthenticated(true);
//       setLoading(false);
//     });

// Step 3: إدارة حالة Sidebar في الموبايل
//   - const [isSidebarOpen, setIsSidebarOpen] = useState(false);
//   - في الشاشات الكبيرة: Sidebar ظاهر دائماً
//   - في الموبايل: مخفي ويظهر بزر hamburger

// Step 4: عرض شاشة تحميل أثناء التحقق
//   - if (loading) return <div className="min-h-screen flex items-center justify-center">جاري التحميل...</div>
//   - if (!isAuthenticated) return null;  // سيتم redirect

// Step 5: بناء هيكل الصفحة
//   - <div className="min-h-screen bg-gray-50">
//     - <Sidebar /> — ثابت على اليمين (RTL)
//     - <Header onMenuToggle={() => setIsSidebarOpen(!isSidebarOpen)} />
//     - <main className="mr-[250px] mt-16 p-6">  // mr لأن Sidebar على اليمين RTL
//         {children}
//       </main>
//   - </div>

// Step 6: Responsive — الموبايل
//   - Sidebar: hidden lg:block (مخفي في الموبايل)
//   - عند isSidebarOpen: أظهر Sidebar مع overlay خلفي
//   - main: mr-0 lg:mr-[250px] (بدون margin في الموبايل)
//   - Header: right-0 lg:right-[250px]

// --- Notes ---
// - هذا المكون يلف كل صفحات لوحة التحكم (ما عدا صفحة تسجيل الدخول)
// - التحقق من المصادقة يحدث هنا — لا حاجة لتكراره في كل صفحة
// - يمكن استخدام AuthContext بدل onAuthStateChanged مباشرة
// - Overlay في الموبايل: خلفية شفافة سوداء عند فتح Sidebar
// - أضف transition للـ Sidebar عند الفتح/الإغلاق في الموبايل
