// ============================================================
// File: Card.tsx
// Purpose: مكون البطاقة - لعرض المحتوى في إطار مُنسق
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// import { LucideIcon } from 'lucide-react';  // نوع الأيقونة

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface CardProps {
//       children: React.ReactNode;
//       title?: string;
//       className?: string;
//       icon?: LucideIcon;    // أيقونة اختيارية بجانب العنوان
//     }

// Step 2: بناء المكون
//   - <div className={`bg-white rounded-lg shadow-md p-6 ${className}`}>
//     - إذا كان هناك عنوان:
//       <div className="flex items-center gap-2 mb-4">
//         {icon && <Icon className="h-5 w-5 text-primary-600" />}
//         <h3 className="text-lg font-semibold text-gray-800">{title}</h3>
//       </div>
//     - {children}
//   - </div>

// Step 3: التصدير
//   - export default function Card({ children, title, className = '', icon: Icon }: CardProps)

// --- Notes ---
// - البطاقة بسيطة ومرنة — تُستخدم في Dashboard stats, forms, sections
// - shadow-md يعطي ظل متوسط — يمكن تغييره حسب الاستخدام
// - rounded-lg للزوايا المدورة
// - className prop يسمح بتخصيص إضافي من الخارج
// - الأيقونة اختيارية — تُعرض فقط إذا مُررت
// - يمكن إضافة prop footer لمحتوى أسفل البطاقة (مستقبلي)
