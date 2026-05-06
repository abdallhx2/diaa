'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';

interface LessonModalProps {
  isOpen: boolean;
  onClose: () => void;
  mode: 'add' | 'edit';
  initialData?: {
    title: string;
    subject: string;
    summary?: string;
  };
}

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

const uploadZoneStyle: React.CSSProperties = {
  border: '2px dashed var(--border)',
  borderRadius: 14,
  padding: '28px 20px',
  textAlign: 'center',
  background: 'rgba(244, 242, 248, 0.6)',
  cursor: 'pointer',
  transition: 'border-color 0.2s, background 0.2s',
};

export default function LessonModal({ isOpen, onClose, mode, initialData }: LessonModalProps) {
  const [title, setTitle] = useState('');
  const [subject, setSubject] = useState('');
  const [summary, setSummary] = useState('');

  useEffect(() => {
    if (isOpen && initialData) {
      setTitle(initialData.title || '');
      setSubject(initialData.subject || '');
      setSummary(initialData.summary || '');
    } else if (isOpen && !initialData) {
      setTitle('');
      setSubject('');
      setSummary('');
    }
  }, [isOpen, initialData]);

  const handleSave = () => {
    // TODO: integrate with API
    onClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={mode === 'add' ? 'إضافة درس' : 'تعديل الدرس'}
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
            حفظ الدرس
          </button>
        </>
      }
    >
      <div className="flex flex-col gap-4">
        {/* Lesson Title */}
        <div>
          <label style={labelStyle}>عنوان الدرس</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            style={inputStyle}
            placeholder="أدخل عنوان الدرس"
          />
        </div>

        {/* Subject */}
        <div>
          <label style={labelStyle}>المادة</label>
          <select
            value={subject}
            onChange={(e) => setSubject(e.target.value)}
            style={inputStyle}
          >
            <option value="">— اختر المادة —</option>
            <option value="لغتي">لغتي</option>
            <option value="علوم">علوم</option>
          </select>
        </div>

        {/* Video Upload */}
        <div>
          <label style={labelStyle}>فيديو الدرس</label>
          <div
            style={uploadZoneStyle}
            className="upload-zone"
            onMouseEnter={(e) => {
              e.currentTarget.style.borderColor = 'var(--purple)';
              e.currentTarget.style.background = 'var(--purple-dim)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.borderColor = 'var(--border)';
              e.currentTarget.style.background = 'rgba(244, 242, 248, 0.6)';
            }}
          >
            <div style={{ fontSize: '1.8rem', marginBottom: 6 }}>🎬</div>
            <div style={{ fontSize: '0.88rem', fontWeight: 700, color: 'var(--text)', marginBottom: 4 }}>
              انقر لرفع الفيديو
            </div>
            <div style={{ fontSize: '0.75rem', color: 'var(--text-sm)' }}>
              MP4 · MOV · الحد الأقصى 500 MB
            </div>
          </div>
        </div>

        {/* Audio Upload */}
        <div>
          <label style={labelStyle}>رفع صوت الملخص</label>
          <div
            style={uploadZoneStyle}
            className="upload-zone"
            onMouseEnter={(e) => {
              e.currentTarget.style.borderColor = 'var(--purple)';
              e.currentTarget.style.background = 'var(--purple-dim)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.borderColor = 'var(--border)';
              e.currentTarget.style.background = 'rgba(244, 242, 248, 0.6)';
            }}
          >
            <div style={{ fontSize: '1.8rem', marginBottom: 6 }}>🔊</div>
            <div style={{ fontSize: '0.88rem', fontWeight: 700, color: 'var(--text)', marginBottom: 4 }}>
              انقر لرفع الملف الصوتي
            </div>
            <div style={{ fontSize: '0.75rem', color: 'var(--text-sm)' }}>
              MP3 · WAV · الحد الأقصى 50 MB
            </div>
          </div>
        </div>

        {/* Summary Text */}
        <div>
          <label style={labelStyle}>نص الملخص</label>
          <textarea
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
            style={{
              ...inputStyle,
              resize: 'vertical',
              minHeight: 120,
            }}
            placeholder="اكتب ملخص الدرس هنا..."
          />
        </div>
      </div>
    </Modal>
  );
}
