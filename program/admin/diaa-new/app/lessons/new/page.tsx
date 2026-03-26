// ============================================================
// File: lessons/new/page.tsx
// Purpose: صفحة إضافة درس جديد
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

import { useRouter } from 'next/navigation';
import DashboardLayout from '@/components/layout/DashboardLayout';
import LessonForm from '@/components/lessons/LessonForm';
import { createLesson } from '@/services/lessons';
import { LessonCreateRequest } from '@/types/lesson';
import { toast } from 'sonner';
import { ArrowRight } from 'lucide-react';

export default function NewLessonPage() {
  const router = useRouter();

  // Step 3: معالجة إرسال النموذج
  const handleCreate = async (data: LessonCreateRequest) => {
    try {
      await createLesson(data);
      toast.success('تم إضافة الدرس بنجاح');
      router.push('/lessons');
    } catch {
      toast.error('حدث خطأ أثناء إضافة الدرس');
    }
  };

  return (
    <DashboardLayout>
      <div className="p-6">

        {/* Step 4: زر العودة */}
        <button
          onClick={() => router.push('/lessons')}
          className="flex items-center gap-2 text-gray-500 hover:text-gray-700 mb-6"
        >
          <ArrowRight className="h-4 w-4" />
          العودة للدروس
        </button>

        {/* Step 1: عنوان الصفحة */}
        <h1 className="text-2xl font-bold text-gray-800 mb-6">إضافة درس جديد</h1>

        {/* Step 2: النموذج */}
        <div className="max-w-2xl">
          <LessonForm onSubmit={handleCreate} />
        </div>

      </div>
    </DashboardLayout>
  );
}
