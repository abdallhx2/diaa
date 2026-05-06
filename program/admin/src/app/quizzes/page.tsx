'use client';

import { useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import QuestionModal from '@/components/quizzes/QuestionModal';
import { Edit, Trash2 } from 'lucide-react';

type TabKey = 'lesson' | 'reading' | 'writing';

interface QuizRow {
  id: string;
  lesson?: string;
  question: string;
  subject?: string;
  correctAnswer: string;
}

const tabData: Record<TabKey, { label: string; columns: string[]; rows: QuizRow[] }> = {
  lesson: {
    label: 'اختبر بالدرس',
    columns: ['الدرس', 'السؤال', 'الإجابة الصحيحة', 'الإجراءات'],
    rows: [
      { id: '1', lesson: 'الحروف الهجائية', question: 'ما هو الحرف الأول في الأبجدية؟', correctAnswer: 'الألف' },
      { id: '2', lesson: 'الحروف الهجائية', question: 'كم عدد حروف اللغة العربية؟', correctAnswer: '٢٨' },
      { id: '3', lesson: 'الكائنات الحية', question: 'أي من التالي كائن حي؟', correctAnswer: 'النبتة' },
    ],
  },
  reading: {
    label: 'تمرن قراءة',
    columns: ['السؤال / النص', 'المادة', 'الإجابة الصحيحة', 'الإجراءات'],
    rows: [
      { id: '4', question: 'اقرأ الكلمة: "كِتَابٌ"', subject: 'لغتي', correctAnswer: 'كِتَابٌ' },
      { id: '5', question: 'اقرأ الجملة: "الشَّمْسُ مُشْرِقَةٌ"', subject: 'علوم', correctAnswer: 'الشمس مشرقة' },
    ],
  },
  writing: {
    label: 'تمرن كتابة',
    columns: ['السؤال', 'المادة', 'الإجابة الصحيحة', 'الإجراءات'],
    rows: [
      { id: '6', question: 'اكتب كلمة "مَدْرَسَةٌ"', subject: 'لغتي', correctAnswer: 'مدرسة' },
      { id: '7', question: 'اكتب اسم فصل الشتاء', subject: 'علوم', correctAnswer: 'الشتاء' },
    ],
  },
};

export default function QuizzesPage() {
  const [activeTab, setActiveTab] = useState<TabKey>('lesson');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editData, setEditData] = useState<{ type: string; question: string; options: string[]; correct: string } | undefined>(undefined);
  const [modalMode, setModalMode] = useState<'add' | 'edit'>('add');

  const tabs: TabKey[] = ['lesson', 'reading', 'writing'];
  const current = tabData[activeTab];

  const handleAdd = () => {
    setModalMode('add');
    setEditData(undefined);
    setIsModalOpen(true);
  };

  const handleEdit = (row: QuizRow) => {
    setModalMode('edit');
    setEditData({
      type: activeTab === 'lesson' ? 'lesson' : activeTab === 'reading' ? 'reading' : 'writing',
      question: row.question,
      options: ['', '', '', ''],
      correct: row.correctAnswer,
    });
    setIsModalOpen(true);
  };

  return (
    <DashboardLayout>
      <div style={{ padding: '0' }}>
        {/* Header */}
        <div className="flex items-center justify-between" style={{ marginBottom: 20 }}>
          <div>
            <h1 style={{ fontSize: '1.4rem', fontWeight: 800, color: 'var(--text)', margin: 0 }}>
              الاختبارات
            </h1>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-sm)', margin: '4px 0 0' }}>
              إدارة الأسئلة والتمارين
            </p>
          </div>
          <button
            onClick={handleAdd}
            style={{
              background: 'var(--purple)',
              color: '#fff',
              border: 'none',
              borderRadius: 'var(--r-sm)',
              padding: '10px 20px',
              fontSize: '0.85rem',
              fontWeight: 700,
              cursor: 'pointer',
              transition: 'background 0.2s',
            }}
            onMouseEnter={(e) => (e.currentTarget.style.background = 'var(--purple-dk)')}
            onMouseLeave={(e) => (e.currentTarget.style.background = 'var(--purple)')}
          >
            إضافة سؤال
          </button>
        </div>

        {/* Tab buttons */}
        <div className="flex gap-2" style={{ marginBottom: 18 }}>
          {tabs.map((tab) => {
            const isActive = activeTab === tab;
            return (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                style={{
                  padding: '6px 12px',
                  fontSize: '0.75rem',
                  fontWeight: 700,
                  borderRadius: 'var(--r-sm)',
                  border: isActive ? 'none' : '1.5px solid var(--border)',
                  background: isActive ? 'var(--purple)' : 'transparent',
                  color: isActive ? '#fff' : 'var(--text-sm)',
                  cursor: 'pointer',
                  transition: 'all 0.2s',
                }}
              >
                {tabData[tab].label}
              </button>
            );
          })}
        </div>

        {/* Tab content - Table card */}
        <div
          style={{
            background: 'var(--white)',
            borderRadius: 'var(--r)',
            boxShadow: 'var(--shadow)',
            overflow: 'hidden',
          }}
        >
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ background: 'var(--bg)' }}>
                  {current.columns.map((col) => (
                    <th
                      key={col}
                      style={{
                        padding: '12px 16px',
                        fontSize: '0.78rem',
                        fontWeight: 700,
                        color: 'var(--text-sm)',
                        textAlign: 'right',
                        borderBottom: '1px solid var(--border)',
                      }}
                    >
                      {col}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {current.rows.map((row) => (
                  <tr
                    key={row.id}
                    style={{ borderBottom: '1px solid var(--border)' }}
                    className="hover:bg-[var(--bg)]"
                  >
                    {/* First column: lesson name or question */}
                    <td style={{ padding: '12px 16px', fontSize: '0.84rem', color: 'var(--text)' }}>
                      {activeTab === 'lesson' ? row.lesson : row.question}
                    </td>
                    {/* Second column: question or subject */}
                    <td style={{ padding: '12px 16px', fontSize: '0.84rem', color: 'var(--text)' }}>
                      {activeTab === 'lesson' ? row.question : row.subject}
                    </td>
                    {/* Correct answer */}
                    <td style={{ padding: '12px 16px', fontSize: '0.84rem', color: 'var(--text)', fontWeight: 600 }}>
                      {row.correctAnswer}
                    </td>
                    {/* Actions */}
                    <td style={{ padding: '12px 16px' }}>
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleEdit(row)}
                          className="transition-colors"
                          style={{
                            background: 'none',
                            border: 'none',
                            cursor: 'pointer',
                            color: 'var(--purple)',
                            padding: 4,
                          }}
                          title="تعديل"
                        >
                          <Edit size={16} />
                        </button>
                        <button
                          className="transition-colors"
                          style={{
                            background: 'none',
                            border: 'none',
                            cursor: 'pointer',
                            color: 'var(--red)',
                            padding: 4,
                          }}
                          title="حذف"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Question Modal */}
      <QuestionModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        mode={modalMode}
        initialData={editData}
      />
    </DashboardLayout>
  );
}
