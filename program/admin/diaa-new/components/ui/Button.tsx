// ============================================================
// File: Button.tsx
// Purpose: مكون الزر القابل لإعادة الاستخدام - يدعم عدة أنماط وأحجام
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// import { ButtonHTMLAttributes } from 'react';
// import { Loader2 } from 'lucide-react';  // أيقونة التحميل الدوّارة

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
//       variant?: 'primary' | 'secondary' | 'danger';
//       size?: 'sm' | 'md' | 'lg';
//       isLoading?: boolean;
//       children: React.ReactNode;
//     }

// Step 2: تعريف أنماط Tailwind لكل variant
//   - const variants = {
//       primary: 'bg-primary-600 text-white hover:bg-primary-700 focus:ring-primary-500',
//       secondary: 'bg-gray-100 text-gray-700 hover:bg-gray-200 focus:ring-gray-500 border border-gray-300',
//       danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500',
//     };

// Step 3: تعريف أنماط الأحجام
//   - const sizes = {
//       sm: 'px-3 py-1.5 text-sm',
//       md: 'px-4 py-2 text-base',
//       lg: 'px-6 py-3 text-lg',
//     };

// Step 4: بناء المكون
//   - الأنماط المشتركة: 'inline-flex items-center justify-center rounded-lg font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed'
//   - دمج: className المشترك + variants[variant] + sizes[size] + className من Props

// Step 5: حالة التحميل
//   - if (isLoading): أظهر <Loader2 className="animate-spin ml-2 h-4 w-4" /> بجانب النص
//   - اجعل الزر disabled أثناء التحميل
//   - ml-2 (وليس mr-2) لأن الاتجاه RTL

// Step 6: التصدير
//   - export default function Button({ variant = 'primary', size = 'md', isLoading = false, children, className, ...props }: ButtonProps)

// --- Notes ---
// - المكون يرث جميع خصائص HTML button عبر ButtonHTMLAttributes
// - استخدم cn() أو template literals لدمج الـ classes
// - focus:ring للوصولية (accessibility) — مهم للمستخدمين الذين يتنقلون بلوحة المفاتيح
// - disabled:opacity-50 يُعطي مظهر معطل واضح
// - يمكن إضافة prop لأيقونة (icon) بجانب النص مستقبلاً
