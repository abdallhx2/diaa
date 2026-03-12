// ============================================================
// File: Modal.tsx
// Purpose: مكون النافذة المنبثقة - للتأكيدات والنماذج
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

'use client';

// Step 1: الاستيرادات
import { useEffect } from 'react';
import { X } from 'lucide-react';

// Step 2: تعريف Props
interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
}

// Step 3 + 4 + 5 + 6: بناء المكون وتصديره
export default function Modal({ isOpen, onClose, title, children, footer }: ModalProps) {

  // Step 3: إغلاق عند Escape
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onClose]);

  // Step 4: إخفاء النافذة إذا مغلقة
  if (!isOpen) return null;

  return (
    // Step 5: طبقة الخلفية
    <div className="fixed inset-0 z-50 flex items-center justify-center">

      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/50"
        onClick={onClose}
      />

      {/* Step 6: بطاقة النافذة */}
      <div
        className="relative z-50 bg-white rounded-lg shadow-xl w-full max-w-md mx-4"
        onClick={(e) => e.stopPropagation()}
      >
        {/* الرأس */}
        <div className="flex items-center justify-between p-4 border-b">
          <h2 className="text-lg font-bold text-gray-800">{title}</h2>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* المحتوى */}
        <div className="p-4">{children}</div>

        {/* الذيل (اختياري) */}
        {footer && (
          <div className="p-4 border-t flex gap-2 justify-end">
            {footer}
          </div>
        )}
      </div>
    </div>
  );
}

// --- أمثلة الاستخدام ---
// <Modal isOpen={isOpen} onClose={() => setIsOpen(false)} title="تأكيد الحذف">
//   <p>هل أنت متأكد؟</p>
// </Modal>
//
// <Modal
//   isOpen={is