// ============================================================
// File: Table.tsx
// Purpose: مكون الجدول القابل لإعادة الاستخدام
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// Step 1: الاستيرادات
import { flexRender, Table as TanStackTable } from '@tanstack/react-table';

// Step 2: تعريف Props
interface TableProps<T> {
  columns: { key: string; label: string; render?: (item: T) => React.ReactNode }[];
  data: T[];
  onRowClick?: (item: T) => void;
}

// Step 3 + 4 + 5 + 6: بناء المكون وتصديره
export default function Table<T>({ columns, data, onRowClick }: TableProps<T>) {
  return (
    // Step 3: الهيكل الخارجي
    <div className="overflow-x-auto rounded-lg border border-gray-200">
      <table className="w-full text-sm">

        {/* Step 4: رأس الجدول */}
        <thead className="bg-gray-50 border-b">
          <tr>
            {columns.map((col) => (
              <th
                key={col.key}
                className="px-4 py-3 text-right font-semibold text-gray-600"
              >
                {col.label}
              </th>
            ))}
          </tr>
        </thead>

        {/* Step 5: جسم الجدول */}
        <tbody className="divide-y divide-gray-100">

          {/* Step 6: حالة الجدول الفارغ */}
          {data.length === 0 ? (
            <tr>
              <td
                colSpan={columns.length}
                className="text-center py-8 text-gray-400"
              >
                لا توجد بيانات
              </td>
            </tr>
          ) : (
            data.map((item, index) => (
              <tr
                key={index}
                className="hover:bg-gray-50 transition-colors cursor-pointer even:bg-gray-50/50"
                onClick={() => onRowClick?.(item)}
              >
                {columns.map((col) => (
                  <td key={col.key} className="px-4 py-3">
                    {col.render ? col.render(item) : String((item as any)[col.key] ?? '')}
                  </td>
                ))}
              </tr>
            ))
          )}
        </tbody>

      </table>
    </div>
  );
}

// --- أمثلة الاستخدام ---
// <Table
//   columns={[
//     { key: 'name', label: 'الاسم' },
//     { key: 'status', label: 'الحالة', render: (item) => <Badge text={item.status} /> },
//   ]}
//   data={users}
//   onRowClick={(user) => router.push(`/users/${user.id}`)}
// />