// ============================================================
// File: Table.tsx
// Purpose: مكون الجدول القابل لإعادة الاستخدام - يدعم TanStack Table
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// import { flexRender, Table as TanStackTable } from '@tanstack/react-table';

// --- Implementation Steps ---
// Step 1: تعريف Props (طريقتان مدعومتان)
//   - الطريقة 1 — بيانات مباشرة:
//     interface TableProps<T> {
//       columns: { key: string; label: string; render?: (item: T) => React.ReactNode }[];
//       data: T[];
//       onRowClick?: (item: T) => void;
//     }
//   - الطريقة 2 — TanStack Table instance:
//     interface TanStackTableProps<T> {
//       table: TanStackTable<T>;
//       onRowClick?: (item: T) => void;
//     }

// Step 2: بناء الهيكل الخارجي للجدول
//   - <div className="overflow-x-auto rounded-lg border border-gray-200">
//   - <table className="w-full text-sm">

// Step 3: بناء رأس الجدول (thead)
//   - <thead className="bg-gray-50 border-b">
//   - <th className="px-4 py-3 text-right font-semibold text-gray-600">
//   - لكل عمود: اعرض label مع إمكانية الفرز (إذا TanStack)

// Step 4: بناء جسم الجدول (tbody)
//   - <tbody className="divide-y divide-gray-100">
//   - لكل صف: <tr className="hover:bg-gray-50 transition-colors cursor-pointer" onClick={() => onRowClick?.(item)}>
//   - لكل خلية: <td className="px-4 py-3">
//   - Zebra striping: even:bg-gray-50/50

// Step 5: حالة الجدول الفارغ
//   - إذا لا توجد بيانات: <tr><td colSpan={columns.length} className="text-center py-8 text-gray-400">لا توجد بيانات</td></tr>

// Step 6: التصدير
//   - export default function Table<T>({ ... }: TableProps<T>)

// --- Notes ---
// - text-right في thead لأن الاتجاه RTL
// - overflow-x-auto يسمح بالتمرير الأفقي في الشاشات الصغيرة
// - hover:bg-gray-50 يُعطي تأثير بصري عند تمرير الماوس
// - cursor-pointer إذا كان onRowClick مُعرّفاً
// - يمكن دعم كلا الطريقتين (بيانات مباشرة أو TanStack) في نفس المكون
// - divide-y يُضيف خطوط فاصلة بين الصفوف تلقائياً
