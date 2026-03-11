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

  // Step 2: جلب الأسئلة
  const fetchQuizzes = async () => {
    setLoading(true);
    try {
      const res = await getQuizzes({
        quiz_type: quizTypeFilter === 'all' ? undefined : quizTypeFilter,
      });
      setQuizzes(res);
    } catch {
      toast.error('حدث خطأ أثناء جلب الأسئلة');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchQuizzes();
  }, [quizTypeFilter]);

  return (
    <DashboardLayout>
      <div className="p-6">

        {/* Step 3: شريط التصفية */}
        <div className="flex justify-between items-center mb-6">
          <select
            value={quizTypeFilter}
            onChange={(e) => setQuizTypeFilter(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700"
          >
            <option value="all">الكل</option>
            <option value="reading">قراءة
