'use client';

import { useEffect, useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import Card from '@/components/ui/Card';
import Badge from '@/components/ui/Badge';
import api from '@/services/api';

interface RecentLesson {
  title: string;
  subject: string;
}

export default function DashboardPage() {
  const [lessons, setLessons] = useState<RecentLesson[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDashboard = async () => {
      try {
        const response = await api.get('/admin/dashboard');
        const data = response.data.data || response.data;
        if (data.recent_lessons && data.recent_lessons.length > 0) {
          setLessons(data.recent_lessons);
        } else {
          setLessons(getMockLessons());
        }
      } catch {
        setLessons(getMockLessons());
      } finally {
        setLoading(false);
      }
    };

    fetchDashboard();
  }, []);

  function getMockLessons(): RecentLesson[] {
    return [
      { title: 'الحروف الهجائية', subject: 'لغتي' },
      { title: 'الكائنات الحية', subject: 'علوم' },
      { title: 'الأرقام من ١ إلى ١٠', subject: 'لغتي' },
      { title: 'الطقس والفصول', subject: 'علوم' },
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

  return (
    <DashboardLayout>
      {/* Page Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-xl font-black text-[var(--text)]">لوحة التحكم</h1>
          <p className="text-xs text-[var(--text-sm)] mt-0.5">نظرة عامة على المنصة</p>
        </div>
      </div>

      {/* Recent Lessons Card */}
      <Card>
        <h2 className="text-sm font-bold text-[var(--text)] mb-4">آخر الدروس المضافة</h2>
        {loading ? (
          <div className="animate-pulse space-y-3">
            {[1, 2, 3].map((i) => (
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
                </tr>
              </thead>
              <tbody>
                {lessons.map((lesson, idx) => (
                  <tr key={idx} className="border-t border-[var(--bg)]">
                    <td className="py-3 px-5 text-sm text-[var(--text)]">{lesson.title}</td>
                    <td className="py-3 px-5 text-sm">
                      <Badge variant={getSubjectBadgeVariant(lesson.subject)}>
                        {lesson.subject}
                      </Badge>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </DashboardLayout>
  );
}
