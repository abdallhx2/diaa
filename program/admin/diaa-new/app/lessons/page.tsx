// ============================================================
// File: lessons/page.tsx
// Purpose: صفحة قائمة الدروس - عرض وبحث وتصفية الدروس التعليمية
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import DashboardLayout from '@/components/layout/DashboardLayout';
import LessonTable from '@/components/lessons/LessonTable';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import { getLessons } from '@/services/lessons';
import { Lesson } from '@/types/lesson';
import { PlusCircle, Search } from 'lucide-react';

export default function LessonsPage() {
  const router = useRouter();

  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [subjectFilter, setSubjectFilter] = useState('');
  const [gradeFilter, setGradeFilter] = useState('');

  const fetchLessons = async () => {
    setLoading(true);
    try {
      const res = await getLessons({
        search: searchQuery,
        subject: subjectFilter,
        grade: gradeFilter,
      });
      setLessons(res);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchLessons();
    }, 300);
    return () => clearTimeout(timer);
  }, [searchQuery, subjectFilter, gradeFilter]);

  return (
    <DashboardLayout>
      <div className="p-6">

        <h1 className="text-2xl font-bold text-gray-800 mb-6">الدروس</h1>

        <div className="flex justify-between items-center gap-4 mb-6 flex-wrap">
          <div className="flex gap-3 flex-1 flex-wrap">

            <div className="relative flex-1">
              <Search className="absolute right-3 top-2.5 h-4 w-4 text-gray-400" />
              <Input
                placeholder="البحث بعنوان الدرس..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pr-9"
              />
            </div>

            {/* المواد */}
            <select
              value={subjectFilter}
              onChange={(e) => setSubjectFilter(e.target.value)}
              className="px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-700"
            >
              <option value="">كل المواد</option>
              <option value="لغتي">لغتي</option>
              <option value="علوم">علوم</option>
            </select>

            {/* المراحل */}
            <select
              value={gradeFilter}
              onChange={(e) => setGradeFilter(e.target.value)}
              className="px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-700"
            >
              <option value="">كل المراحل</option>
              <option value="الأول">الصف الأول</option>
              <option value="الثاني">الصف الثاني</option>
              <option value="الثالث">الصف الثالث</option>
            </select>

          </div>

          <Button onClick={() => router.push('/lessons/new')}>
            <PlusCircle className="ml-2 h-4 w-4" />
            إضافة درس جديد
          </Button>
        </div>

        {loading ? (
          <div className="space-y-3">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="h-12 bg-gray-100 rounded-lg animate-pulse" />
            ))}
          </div>
        ) : lessons.length === 0 ? (
          <div className="text-center py-16">
            <p className="text-gray-400 mb-4">لا توجد دروس بعد</p>
            <Button onClick={() => router.push('/lessons/new')}>
              <PlusCircle className="ml-2 h-4 w-4" />
              إضافة درس جديد
            </Button>
          </div>
        ) : (
          <LessonTable lessons={lessons} onRefresh={fetchLessons} />
        )}

      </div>
    </DashboardLayout>
  );
}