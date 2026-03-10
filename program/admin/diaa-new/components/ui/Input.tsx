// ============================================================
// File: Input.tsx
// Purpose: مكون حقل الإدخال - يدعم التسمية ورسائل الخطأ
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// import { InputHTMLAttributes, forwardRef } from 'react';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
//       label?: string;        // نص التسمية فوق الحقل
//       error?: string;        // رسالة الخطأ (تظهر تحت الحقل)
//     }
//   - استخدم forwardRef لدعم React Hook Form register

// Step 2: بناء المكون باستخدام forwardRef
//   - const Input = forwardRef<HTMLInputElement, InputProps>(({ label, error, className, ...props }, ref) => { ... })

// Step 3: عرض التسمية (Label)
//   - {label && <label className="block text-sm font-medium text-gray-700 mb-1">{label}</label>}

// Step 4: عرض حقل الإدخال
//   - <input
//       ref={ref}
//       className="w-full px-4 py-2 border rounded-lg text-gray-900 placeholder-gray-400
//                  focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500
//                  transition-colors duration-200
//                  ${error ? 'border-red-500' : 'border-gray-300'}"
//       {...props}
//     />

// Step 5: عرض رسالة الخطأ
//   - {error && <p className="mt-1 text-sm text-red-500">{error}</p>}

// Step 6: التصدير
//   - Input.displayName = 'Input';
//   - export default Input;

// --- Notes ---
// - forwardRef ضروري لأن React Hook Form يحتاج ref للحقل
// - الحقل يتحول للون الأحمر عند وجود خطأ (border-red-500)
// - placeholder-gray-400 لنص الإرشاد الخافت
// - يمكن إضافة أيقونة داخل الحقل (مثل أيقونة البحث) عبر prop إضافي
// - تأكد من أن text-align يكون right تلقائياً بسبب dir="rtl" على html
