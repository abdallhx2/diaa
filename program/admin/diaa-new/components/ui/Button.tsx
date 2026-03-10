// ============================================================
// File: Button.tsx
// Purpose: مكون الزر القابل لإعادة الاستخدام - يدعم عدة أنماط وأحجام
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// Step 1: الاستيرادات
import { ButtonHTMLAttributes } from 'react';
import { Loader2 } from 'lucide-react';

// Step 2: تعريف Props
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  children: React.ReactNode;
}

// Step 3: أنماط الـ variant
const variants = {
  primary:   'bg-primary-600 text-white hover:bg-primary-700 focus:ring-primary-500',
  secondary: 'bg-gray-100 text-gray-700 hover:bg-gray-200 focus:ring-gray-500 border border-gray-300',
  danger:    'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500',
};

// Step 4: أنماط الأحجام
const sizes = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg',
};

// Step 5 + 6: بناء المكون وتصديره
export default function Button({
  variant = 'primary',
  size = 'md',
  isLoading = false,
  children,
  className,
  ...props
}: ButtonProps) {
  const baseStyles = 'inline-flex items-center justify-center rounded-lg font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed';

  return (
    <button
      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className ?? ''}`}
      disabled={isLoading || props.disabled}
      {...props}
    >
      {children}
      {isLoading && <Loader2 className="animate-spin ml-2 h-4 w-4" />}
    </button>
  );
}

// --- أمثلة الاستخدام ---
// <Button variant="primary">حفظ</Button>
// <Button variant="secondary">إلغاء</Button>
// <Button variant="danger">حذف</Button>
// <Button variant="primary" size="lg" isLoading={true}>جاري الحفظ...</Button>