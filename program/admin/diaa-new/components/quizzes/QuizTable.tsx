// ============================================================
// File: QuizTable.tsx
// Purpose: جدول عرض أسئلة الاختبارات
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

// Step 1: الاستيرادات
import Table from '@/components/ui/Table';
import Badge from '@/components/ui/Badge';
import Button from '@/components/ui/Button';
import { Quiz } from '@/types/quiz';
import { Edit, Trash2 } from 'lucide-react';

// Step 2: تعريف Props
interface QuizTableProps {
  quizzes: Quiz[];
  onEdit?: (id: string) => void;
  onDelete?: (id: string) => void;
  onRefresh?: () => void;
}

// Step 3: بناء المكون
export default function QuizTable({ quizzes, onEdit, onDelete }: QuizTableProps) {

  // Step 4: تعريف أعمدة الجدول
  const columns = [
    {
      key: 'question_text',
      label: 'نص السؤال',
      render: (quiz: Quiz) => (
        <span title={quiz.question_text}>
          {quiz.question_text.substring(0, 50)}
          {quiz.question_text.length > 50 ? '...' : ''}
        </span>
      ),
    },
    {
      key: 'quiz_type',
      label: 'نوع الاختبار',
      render: (quiz: Quiz) => {
        const typeMap = {
          reading: <Badge text="قراءة" variant="info" />,
          writing: <Badge text="كتابة" variant="success" />,
          comprehension: <Badge text="فهم المقروء" variant="warning" />,
        };
        return typeMap[quiz.quiz_type as keyof typeof typeMap] || null;
      },
    },
    {
      key: 'lesson_title',
      label: 'الدرس',
      render: (quiz: Quiz) => (
        <span>{quiz.lesson_title || '—'}</span>
      ),
    },
    {
      key: 'options_count',
      label: 'عدد الخيارات',
      render: (quiz: Quiz) => (
        <span>{quiz.options?.length || 0}</span>
      ),
    },
    {
      key: 'actions',
      label: 'الإجراءات',
      render: (quiz: Quiz) => (
        <div className="flex gap-2" onClick={(e) => e.stopPropagation()}>
          <Button
            variant="secondary"
            size="sm"
            onClick={() => onEdit?.(quiz.id)}
          >
            <Edit className="h-4 w-4" />
          </Button>
          <Button
            variant="danger"
            size="sm"
            onClick={() => {
              if (confirm('هل أنت متأكد من حذف هذا السؤال؟')) {
                onDelete?.(quiz.id);
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
    <Table columns={columns} data={quizzes} />
  );
}
