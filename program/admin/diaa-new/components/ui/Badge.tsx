// ============================================================
// File: Badge.tsx
// Purpose: مكون الشارة - لعرض الحالات والأدوار بألوان مميزة
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface BadgeProps {
//       text: string;
//       variant?: 'success' | 'warning' | 'danger' | 'info';
//     }

// Step 2: تعريف أنماط الألوان لكل variant
//   - const variants = {
//       success: 'bg-green-100 text-green-700',    // نشط، طالب
//       warning: 'bg-yellow-100 text-yellow-700',   // ولي أمر، معلق
//       danger: 'bg-red-100 text-red-700',           // معطل، خطأ
//       info: 'bg-blue-100 text-blue-700',           // مسؤول، معلومة
//     };

// Step 3: بناء المكون
//   - <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${variants[variant]}`}>
//       {text}
//     </span>

// Step 4: التصدير
//   - export default function Badge({ text, variant = 'info' }: BadgeProps)

// --- Notes ---
// - rounded-full يعطي شكل الحبة (pill shape)
// - text-xs font-medium لحجم صغير وواضح
// - تُستخدم في: أدوار المستخدمين، حالة الحساب، أنواع الاختبارات
// - أمثلة الاستخدام:
//   - <Badge text="مسؤول" variant="info" />
//   - <Badge text="نشط" variant="success" />
//   - <Badge text="معطل" variant="danger" />
//   - <Badge text="ولي أمر" variant="warning" />
// - يمكن إضافة أيقونة نقطة ملونة بجانب النص مستقبلاً
