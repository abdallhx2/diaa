'use client';

import { useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import Card from '@/components/ui/Card';
import Badge from '@/components/ui/Badge';
import Modal from '@/components/ui/Modal';

interface Subject {
  id: string;
  name: string;
  icon: string;
  lessonsCount: number;
  questionsCount: number;
}

export default function SubjectsPage() {
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [selectedSubject, setSelectedSubject] = useState<Subject | null>(null);

  const subjects: Subject[] = [
    { id: '1', name: 'لغتي', icon: '\u{1F4DD}', lessonsCount: 14, questionsCount: 58 },
    { id: '2', name: 'علوم', icon: '\u{1F33F}', lessonsCount: 10, questionsCount: 38 },
  ];

  const handleEdit = (subject: Subject) => {
    setSelectedSubject(subject);
    setEditModalOpen(true);
  };

  const handleDelete = (subject: Subject) => {
    // placeholder for delete logic
    console.log('Delete subject:', subject.id);
  };

  return (
    <DashboardLayout>
      {/* Page Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-xl font-black text-[var(--text)]">المواد</h1>
          <p className="text-xs text-[var(--text-sm)] mt-0.5">المواد الدراسية المتاحة</p>
        </div>
      </div>

      {/* Subjects Card */}
      <Card>
        <h2 className="text-sm font-bold text-[var(--text)] mb-4">قائمة المواد</h2>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr>
                <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                  المادة
                </th>
                <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                  عدد الدروس
                </th>
                <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                  عدد الأسئلة
                </th>
                <th className="bg-[var(--bg)] text-xs uppercase text-[var(--text-sm)] py-3 px-5 text-right">
                  الإجراءات
                </th>
              </tr>
            </thead>
            <tbody>
              {subjects.map((subject) => (
                <tr key={subject.id} className="border-t border-[var(--bg)]">
                  <td className="py-3 px-5 text-sm text-[var(--text)]">
                    <span className="inline-flex items-center gap-2">
                      <span>{subject.icon}</span>
                      <span className="font-medium">{subject.name}</span>
                    </span>
                  </td>
                  <td className="py-3 px-5 text-sm text-[var(--text)]">
                    {subject.lessonsCount}
                  </td>
                  <td className="py-3 px-5 text-sm text-[var(--text)]">
                    {subject.questionsCount}
                  </td>
                  <td className="py-3 px-5 text-sm">
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleEdit(subject)}
                        className="w-7 h-7 rounded-[7px] flex items-center justify-center bg-blue-50 text-blue-600 hover:bg-blue-100 transition-colors"
                        title="تعديل"
                      >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                        </svg>
                      </button>
                      <button
                        onClick={() => handleDelete(subject)}
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
      </Card>

      {/* Edit Modal (placeholder - implementation handled by Modal component) */}
      <Modal
        isOpen={editModalOpen}
        onClose={() => {
          setEditModalOpen(false);
          setSelectedSubject(null);
        }}
        title="تعديل المادة"
      >
        {selectedSubject && (
          <p className="text-sm text-[var(--text-sm)]">
            تعديل المادة: {selectedSubject.name}
          </p>
        )}
      </Modal>
    </DashboardLayout>
  );
}
