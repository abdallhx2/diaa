// ============================================================
// File: Badge.tsx
// Purpose: مكون الشارة - لعرض الحالات والأدوار بألوان مميزة
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

interface BadgeProps {
  text: string;
  variant?: 'success' | 'warning' | 'danger' | 'info';
}

const variants = {
  success: 'bg-green-100 text-green-700',
  warning: 'bg-yellow-100 text-yellow-700',
  danger:  'bg-red-100 text-red-700',
  info:    'bg-blue-100 text-blue-700',
};

export default function Badge({ text, variant = 'info' }: BadgeProps) {
  return (
    <span
      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${variants[variant]}`}
    >
      {text}
    </span>
  );
}