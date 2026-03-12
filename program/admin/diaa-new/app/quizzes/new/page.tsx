'use client';

import { useRouter } from 'next/navigation';
import DashboardLayout from '@/components/layout/DashboardLayout';
import QuizForm from '@/components/quizzes/QuizForm';
import { createQuiz } from '@/services/quizzes';
import { QuizCreateRequest } from '@/types/quiz';
import { toast } from 'sonner';

export default function NewQuizPage() {
  const router = useRouter();

  const handleCreate = async (data: QuizCreateRequest) => {
    try {
      await createQuiz(data);
      toast.success('تم إضافة السؤال بنجاح');
      router.push('/quizzes');
    } catch {
      toast.error('حدث خطأ أثناء إضافة السؤال');
    }
  };

  return (
    <DashboardLayout>
      <div className="p-6">

        <button
          onClick={() => router.push('/quizzes')}
          className="text-primary-600 hover:underline mb-6 flex items-center gap-1"
        >
          ← العودة للأسئلة
        </button>

        <h1 className="text-2xl font-bold text-gray-800 mb-6">
          إضافة سؤال جديد
        </h1>

        <div className="max-w-2xl">
          <QuizForm onSubmit={handleCreate} />
        </div>

      </div>
    </DashboardLayout>
  );
}
