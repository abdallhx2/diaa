// ============================================================
// File: Input.tsx
// Purpose: مكون حقل الإدخال - يدعم التسمية ورسائل الخطأ
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// Step 1: الاستيرادات
import { InputHTMLAttributes, forwardRef } from 'react';

// Step 2: تعريف Props
interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

// Step 3 + 4 + 5 + 6: بناء المكون باستخدام forwardRef
const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, className, ...props }, ref) => {
    return (
      <div className="w-full">

        {/* Step 3: التسمية */}
        {label && (
          <label className="block text-sm font-medium text-gray-700 mb-1">
            {label}
          </label>
        )}

        {/* Step 4: حقل الإدخال */}
        <input
          ref={ref}
          className={`w-full px-4 py-2 border rounded-lg text-gray-900 placeholder-gray-400
            focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500
            transition-colors duration-200
            ${error ? 'border-red-500' : 'border-gray-300'}
            ${className ?? ''}`}
          {...props}
        />

        {/* Step 5: رسالة الخطأ */}
        {error && (
          <p className="mt-1 text-sm text-red-500">{error}</p>
        )}

      </div>
    );
  }
);

// Step 6: التصدير
Input.displayName = 'Input';
export default Input;

// --- أمثلة الاستخدام ---
// <Input label="الاسم" placeholder="أدخل الاسم" />
// <Input label="البريد" error="البريد غير صحيح" />
// <Input type="password" label="كلمة المرور" />