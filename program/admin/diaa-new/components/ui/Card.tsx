// ============================================================
// File: Card.tsx
// Purpose: مكون البطاقة - لعرض المحتوى في إطار مُنسق
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// Step 1: الاستيرادات
import { LucideIcon } from 'lucide-react';

// Step 2: تعريف Props
interface CardProps {
  children: React.ReactNode;
  title?: string;
  className?: string;
  icon?: LucideIcon;
}

// Step 3 + 4: بناء المكون وتصديره
export default function Card({ children, title, className = '', icon: Icon }: CardProps) {
  return (
    <div className={`bg-white rounded-lg shadow-md p-6 ${className}`}>
      {title && (
        <div className="flex items-center gap-2 mb-4">
          {Icon && <Icon className="h-5 w-5 text-primary-600" />}
          <h3 className="text-lg font-semibold text-gray-800">{title}</h3>
        </div>
      )}
      {children}
    </div>
  );
}

// --- أمثلة الاستخدام ---
// <Card title="إحصائيات">...</Card>
// <Card title="الدروس" icon={BookOpen}>...</Card>
// <Card className="mt-4">...</Card>