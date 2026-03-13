// ============================================================
// File: quizzes/page.tsx
// Purpose: صفحة قائمة الاختبارات والأسئلة
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import DashboardLayout from '@/components/layout/DashboardLayout';
import QuizTable from '@/components/quizzes/QuizTable';
import Button from '@/components/ui/Button';
import { getQuizzes } from '@/services/quizzes';
import { Quiz } from '@/types/quiz';
import { PlusCircle } from 'lucide-react';
import { toast } from 'sonner';

export default function QuizzesPage() {
  const router = useRouter();
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);
  const [loading, setLoading] = useState(false);
  const [quizTypeFilter, setQuizTypeFilter] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchQuizzes = async () => {
    setLoading(true);
    try {
      const res = await getQuizzes({
        quiz_type: quizTypeFilter === 'all' ? undefined : quizTypeFilter,
        page: currentPage,
        limit: 10,
      });
      setQuizzes(res.quizzes);
      setTotalPages(res.totalPages);
    } catch {
      toast.error('حدث خطأ أثناء جلب الأسئلة');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchQuizzes();
  }, [quizTypeFilter, currentPage]);

  return (
    <DashboardLayout>
      <div className="p-6">

        <h1 className="text-2xl font-bold text-gray-800 mb-6">الاختبارات</h1>

        {/* شريط التصفية */}
        <div className="flex justify-between items-center mb-6">
          <select
            value={quizTypeFilter}
            onChange={(e) => {
              setQuizTypeFilter(e.target.value);
              setCurrentPage(1);
            }}
            className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700"
          >
            <option value="all">الكل</option>
            <option value="reading">قراءة</option>
            <option value="writing">كتابة</option>
            <option value="comprehension">فهم المقروء</option>
          </select>

          <Button onClick={() => router.push('/quizzes/new')}>
            <PlusCircle className="ml-2 h-4 w-4" />
            إضافة سؤال
          </Button>
        </div>

        {/* جدول الأسئلة */}
        {loading ? (
          <div className="space-y-3">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="h-12 bg-gray-100 rounded-lg animate-pulse" />
            ))}
          </div>
        ) : quizzes.length === 0 ? (
          <div className="text-center py-8 text-gray-400">
            لا توجد أسئلة بعد. أضف سؤالاً جديداً.
          </div>
        ) : (
          <QuizTable
            quizzes={quizzes}
            onEdit={(id) => router.push(`/quizzes/${id}`)}
            onDelete={async () => fetchQuizzes()}
            onRefresh={fetchQuizzes}
          />
        )}

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="flex justify-center items-center gap-2 mt-6">
            <Button
              variant="secondary"
              size="sm"
              onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
              disabled={currentPage === 1}
            >
              السابق
            </Button>
            {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
              <Button
                key={page}
                variant={page === currentPage ? 'primary' : 'secondary'}
                size="sm"
                onClick={() => setCurrentPage(page)}
              >
                {page}
              </Button>
            ))}
            <Button
              variant="secondary"
              size="sm"
              onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
              disabled={currentPage === totalPages}
            >
              التالي
            </Button>
          </div>
        )}

      </div>
    </DashboardLayout>
  );
}