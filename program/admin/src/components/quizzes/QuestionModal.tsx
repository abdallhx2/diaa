'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';

interface QuestionModalProps {
  isOpen: boolean;
  onClose: () => void;
  mode: 'add' | 'edit';
  initialData?: {
    type: string;
    lessonId?: string;
    question: string;
    options: string[];
    correct: string;
  };
}

const questionTypes = [
  { value: 'lesson', label: 'اختبر بالدرس' },
  { value: 'reading', label: 'تمرن قراءة' },
  { value: 'writing', label: 'تمرن كتابة' },
];

const subjects = [
  { value: '', label: 'الكل' },
  { value: 'لغتي', label: 'لغتي' },
  { value: 'علوم', label: 'علوم' },
];

const lessons = [
  { value: 'letters', label: 'الحروف الهجائية' },
  { value: 'numbers', label: 'الأرقام من ١ إلى ١٠' },
  { value: 'living', label: 'الكائنات الحية' },
  { value: 'weather', label: 'الطقس والفصول' },
];

const optionLabels = ['أ', 'ب', 'ج', 'د'];

const inputStyle: React.CSSProperties = {
  width: '100%',
  padding: '10px 14px',
  border: '1.5px solid var(--border)',
  borderRadius: 'var(--r-sm)',
  fontSize: '0.84rem',
  color: 'var(--text)',
  background: 'var(--white)',
  outline: 'none',
  transition: 'border-color 0.2s',
};

const labelStyle: React.CSSProperties = {
  display: 'block',
  fontSize: '0.8rem',
  fontWeight: 700,
  color: 'var(--text)',
  marginBottom: 6,
};

export default function QuestionModal({ isOpen, onClose, mode, initialData }: QuestionModalProps) {
  const [type, setType] = useState('lesson');
  const [subjectFilter, setSubjectFilter] = useState('');
  const [lessonId, setLessonId] = useState('');
  const [question, setQuestion] = useState('');
  const [options, setOptions] = useState(['', '', '', '']);
  const [correctIndex, setCorrectIndex] = useState('0');

  useEffect(() => {
    if (isOpen && initialData) {
      setType(initialData.type || 'lesson');
      setLessonId(initialData.lessonId || '');
      setQuestion(initialData.question || '');
      setOptions(initialData.options?.length === 4 ? initialData.options : ['', '', '', '']);
      setCorrectIndex('0');
    } else if (isOpen && !initialData) {
      setType('lesson');
      setSubjectFilter('');
      setLessonId('');
      setQuestion('');
      setOptions(['', '', '', '']);
      setCorrectIndex('0');
    }
  }, [isOpen, initialData]);

  const handleOptionChange = (index: number, value: string) => {
    const newOptions = [...options];
    newOptions[index] = value;
    setOptions(newOptions);
  };

  const handleSave = () => {
    // TODO: integrate with API
    onClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={mode === 'add' ? 'إضافة سؤال' : 'تعديل السؤال'}
      footer={
        <>
          <button
            onClick={onClose}
            style={{
              padding: '8px 18px',
              fontSize: '0.82rem',
              fontWeight: 600,
              borderRadius: 'var(--r-sm)',
              border: 'none',
              background: 'transparent',
              color: 'var(--text-sm)',
              cursor: 'pointer',
            }}
          >
            إلغاء
          </button>
          <button
            onClick={handleSave}
            style={{
              padding: '8px 18px',
              fontSize: '0.82rem',
              fontWeight: 700,
              borderRadius: 'var(--r-sm)',
              border: 'none',
              background: 'var(--purple)',
              color: '#fff',
              cursor: 'pointer',
              transition: 'background 0.2s',
            }}
            onMouseEnter={(e) => (e.currentTarget.style.background = 'var(--purple-dk)')}
            onMouseLeave={(e) => (e.currentTarget.style.background = 'var(--purple)')}
          >
            حفظ
          </button>
        </>
      }
    >
      <div className="flex flex-col gap-4">
        {/* Question Type */}
        <div>
          <label style={labelStyle}>نوع السؤال</label>
          <select
            value={type}
            onChange={(e) => setType(e.target.value)}
            style={inputStyle}
          >
            {questionTypes.map((qt) => (
              <option key={qt.value} value={qt.value}>
                {qt.label}
              </option>
            ))}
          </select>
        </div>

        {/* Lesson selector (only for lesson type) */}
        {type === 'lesson' && (
          <>
            <div>
              <label style={labelStyle}>المادة</label>
              <select
                value={subjectFilter}
                onChange={(e) => setSubjectFilter(e.target.value)}
                style={inputStyle}
              >
                {subjects.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label style={labelStyle}>اختر الدرس</label>
              <select
                value={lessonId}
                onChange={(e) => setLessonId(e.target.value)}
                style={inputStyle}
              >
                <option value="">— اختر —</option>
                {lessons.map((l) => (
                  <option key={l.value} value={l.value}>
                    {l.label}
                  </option>
                ))}
              </select>
            </div>
          </>
        )}

        {/* Question text */}
        <div>
          <label style={labelStyle}>السؤال</label>
          <textarea
            value={question}
            onChange={(e) => setQuestion(e.target.value)}
            rows={3}
            style={{
              ...inputStyle,
              resize: 'vertical',
              minHeight: 80,
            }}
            placeholder="اكتب نص السؤال هنا..."
          />
        </div>

        {/* Options */}
        <div>
          <label style={labelStyle}>الخيارات</label>
          <div className="flex flex-col gap-2">
            {options.map((opt, index) => (
              <div key={index} className="flex items-center gap-2">
                <span
                  className="flex items-center justify-center flex-shrink-0"
                  style={{
                    width: 26,
                    height: 26,
                    borderRadius: 6,
                    background: 'var(--purple-dim)',
                    color: 'var(--purple)',
                    fontSize: '0.75rem',
                    fontWeight: 700,
                  }}
                >
                  {optionLabels[index]}
                </span>
                <input
                  type="text"
                  value={opt}
                  onChange={(e) => handleOptionChange(index, e.target.value)}
                  style={{ ...inputStyle, flex: 1 }}
                  placeholder={`الخيار ${optionLabels[index]}`}
                />
              </div>
            ))}
          </div>
        </div>

        {/* Correct answer */}
        <div>
          <label style={labelStyle}>الإجابة الصحيحة</label>
          <select
            value={correctIndex}
            onChange={(e) => setCorrectIndex(e.target.value)}
            style={inputStyle}
          >
            {optionLabels.map((label, index) => (
              <option key={index} value={String(index)}>
                {label}
              </option>
            ))}
          </select>
        </div>
      </div>
    </Modal>
  );
}
