// ============================================================
// File: Sidebar.tsx
// Purpose: الشريط الجانبي للتنقل - يحتوي روابط الصفحات الرئيسية
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// 'use client';
// import { usePathname, useRouter } from 'next/navigation';
// import { LayoutDashboard, Users, BookOpen, FileQuestion, ScrollText, Settings, LogOut } from 'lucide-react';
// import { signOut } from '@/services/auth';

// --- Implementation Steps ---
// Step 1: تعريف قائمة روابط التنقل
//   - const navLinks = [
//       { label: 'لوحة المعلومات', href: '/dashboard', icon: LayoutDashboard },
//       { label: 'المستخدمون', href: '/users', icon: Users },
//       { label: 'الدروس', href: '/lessons', icon: BookOpen },
//       { label: 'الاختبارات', href: '/quizzes', icon: FileQuestion },
//       { label: 'السجلات', href: '/logs', icon: ScrollText },
//       { label: 'الإعدادات', href: '/settings', icon: Settings },
//     ];

// Step 2: الحصول على المسار الحالي لتحديد الرابط النشط
//   - const pathname = usePathname();
//   - const isActive = (href) => pathname.startsWith(href);

// Step 3: بناء هيكل Sidebar
//   - <aside className="fixed right-0 top-0 h-screen w-[250px] bg-white shadow-lg z-40">
//   - الشريط ثابت على اليمين (RTL) بعرض 250px

// Step 4: شعار التطبيق في الأعلى
//   - <div className="p-6 border-b">
//   - شعار Edu Smart أو نص "Edu Smart" بخط كبير
//   - نص فرعي: "لوحة التحكم"

// Step 5: عرض روابط التنقل
//   - <nav className="flex flex-col gap-1 p-4">
//   - لكل رابط: <Link href={href} className={isActive ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50'}>
//   - أيقونة + نص الرابط
//   - rounded-lg px-4 py-3 flex items-center gap-3

// Step 6: زر تسجيل الخروج في الأسفل
//   - <div className="absolute bottom-0 w-full p-4 border-t">
//   - <button onClick={handleLogout}>تسجيل الخروج</button>
//   - handleLogout: signOut() → router.push('/')
//   - أيقونة LogOut + نص

// --- Notes ---
// - الشريط ثابت (fixed) ولا يتحرك مع التمرير
// - في الشاشات الصغيرة (mobile): يجب إخفاء Sidebar — يُدار من DashboardLayout
// - الرابط النشط يُحدد بمقارنة pathname.startsWith(href)
// - z-40 لضمان ظهور Sidebar فوق المحتوى
// - يمكن إضافة animation عند hover (transition-colors duration-200)
