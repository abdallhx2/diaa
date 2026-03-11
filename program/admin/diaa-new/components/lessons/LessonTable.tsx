// ============================================================
// File: LessonTable.tsx
// Purpose: جدول عرض الدروس مع الإجراءات
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useRouter } from 'next/navigation';
import Table from '@/components/ui/Table';
import Button from '@/components/ui/Button';
import { Lesson } from '@/types/lesson';
import { Edit, Trash2 } from 'lucide-react';
import { format } from 'date-fns';

// Step 2: تعريف Props
interface LessonTableProps {
  lessons: Lesson[];
  onDelete?: (id: string) => void;
  onRefresh?: () => void;
}

// Step 3 + 4: بناء المكون
export default function LessonTable({ lessons, onDelete, onRefresh }: LessonTableProps) {
  const router = useRouter();

  // Step 3: تعريف أعمدة الجدول
  const columns = [
    {
      key: 'title',
      label: 'عنوان الدرس',
    },
    {
      key: 'subject',
      label: 'المادة',
    },
    {
      key: 'grade_level',
      label: 'المرحلة الدراسية',
    },
    {
      key: 'qr_code',
      label: 'رمز QR',
      render: (lesson: Lesson) => (
        <span className="text-xs text-gray-500 truncate max-w-[100px] block">
          {lesson.qr_code || '—'}
        </span>
      ),
    },
    {
      key: 'created_at',
      label: 'تاريخ الإنشاء',
      render: (lesson: Lesson) => (
        <span>{lesson.created_at ? format(new Date(lesson.created_at), 'dd/MM/yyyy') : '—'}</span>
      ),
    },
    {
      key: 'actions',
      label: 'الإجراءات',
      render: (lesson: Lesson) => (
        <div className="flex gap-2" onClick={(e) => e.stopPropagation()}>
          {/* زر التعديل */}
          <Button
            variant="secondary"
            size="sm"
            onClick={() => router.push(`/lessons/${lesson.id}`)}
          >
            <Edit className="h-4 w-4" />
          </Button>
          {/* زر الحذف */}
          <Button
            variant="danger"
            size="sm"
            onClick={() => {
              if (confirm('هل أنت متأكد من حذف هذا الدرس؟')) {
                onDelete?.(lesson.id);
              }
            }}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    // Step 4: عرض الجدول
    <Table
      columns={columns}
      data={lessons}
      onRowClick={(lesson) => router.push(`/lessons/${lesson.id}`)}
    />
  );
}
