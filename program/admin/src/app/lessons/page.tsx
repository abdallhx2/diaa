'use client';

import { useEffect, useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import Card from '@/components/ui/Card';
import Badge from '@/components/ui/Badge';
import LessonModal from '@/components/lessons/LessonModal';
import api from '@/services/api';

interface LessonItem {
  id: string;
  title: string;
  subject: string;
}

export default function LessonsPage() {
  const [lessons, setLessons] = useState<LessonItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [addModalOpen, setAddModalOpen] = useState(false);

  useEffect(() => {
    const fetchLessons = async () => {
      try {
        const response = await api.get('/admin/lessons');
        const data = response.data.data || response.data;
        const items = data.items || data.lessons || data;
        if (Array.isArray(items) && items.length > 0) {
          setLessons(items);
        } else {
          setLessons(getMockLessons());
        }
      } catch {
        setLessons(getMockLessons());
      } finally {
        setLoading(false);
      }
    };

    fetchLessons();
  }, []);

  function getMockLessons(): LessonItem[] {
    return [
      { id: '1', title: 'الحروف الهجائية', subject: 'لغتي' },
      { id: '2', title: 'الكائنات الحية', subject: 'علوم' },
      { id: '3', title: 'الأرقام من ١ إلى ١٠', subject: 'لغتي' },
      { id: '4', title: 'الطقس والفصول', subject: 'علوم' },
    ];
  }

  function getSubjectBadgeVariant(subject: string): 'purple' | 'green' | 'blue' | 'amber' | 'red' {
    switch (subject) {
      case 'لغتي':
        return 'purple';
      case 'علوم':
        return 'green';
      default:
        return 'blue';
    }
  }

  const handleEdit = (lesson: LessonItem) => {
    console.log('Edit lesson:', lesson.id);
  };

  const handleDelete = (lesson: LessonItem) => {
    console.log('Delete lesson:', lesson.id);
  };

  return (
    <DashboardLayout>
      {/* Page Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-xl font-black text-[var(--text)]">الدروس</h1>
          <p className="text-xs text-[var(--text-sm)] mt-0.5">إدارة الدروس التعليمية</p>
        </div>
        <button
          onClick={() => setAddModalOpen(true)}
          className="px-4 py-2 rounded-[10px] text-sm font-bold text-white transition-colors"
          style={{ background: 'linear-gradient(135deg, #7C4DBC, #5A2E9A)' }}
        >
          إضافة درس
        </button>
      </div>

      {/* Lessons Card */}
      <Card>
        <h2 className="text-sm font-bold text-[var(--text)] mb-4">قائمة الدروس</h2>
        {loading ? (
          <div className="animate-pulse space-y-3">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="h-10 bg-[var(--bg)] rounded" />
            ))}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr>
                  <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                    عنوان الدرس
                  </th>
                  <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                    المادة
                  </th>
                  <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                    الإجراءات
                  </th>
                </tr>
              </thead>
              <tbody>
                {lessons.map((lesson) => (
                  <tr key={lesson.id} className="border-t border-[var(--bg)]">
                    <td className="py-3 px-5 text-sm text-[var(--text)]">{lesson.title}</td>
                    <td className="py-3 px-5 text-sm">
                      <Badge variant={getSubjectBadgeVariant(lesson.subject)}>
                        {lesson.subject}
                      </Badge>
                    </td>
                    <td className="py-3 px-5 text-sm">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleEdit(lesson)}
                          className="w-7 h-7 rounded-[7px] flex items-center justify-center bg-blue-50 text-blue-600 hover:bg-blue-100 transition-colors"
                          title="تعديل"
                        >
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(lesson)}
                          className="w-7 h-7 rounded-[7px] flex items-center justify-center bg-red-50 text-red-600 hover:bg-red-100 transition-colors"
                          title="حذف"
                        >
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <polyline points="3 6 5 6 21 6" />
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                          </svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      {/* Add Lesson Modal */}
      <LessonModal
        isOpen={addModalOpen}
        onClose={() => setAddModalOpen(false)}
        mode="add"
      />
    </DashboardLayout>
  );
}
