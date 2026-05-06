'use client';

import { useEffect } from 'react';
import { X } from 'lucide-react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
}

export default function Modal({ isOpen, onClose, title, children, footer }: ModalProps) {
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      document.body.style.overflow = 'hidden';
    }
    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.body.style.overflow = 'unset';
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 flex items-center justify-center"
      style={{ zIndex: 1000 }}
    >
      {/* Backdrop */}
      <div
        className="fixed inset-0"
        style={{
          background: 'rgba(46, 26, 80, 0.45)',
          backdropFilter: 'blur(3px)',
        }}
        onClick={onClose}
      />

      {/* Modal box */}
      <div
        role="dialog"
        aria-modal="true"
        className="relative bg-white"
        style={{
          borderRadius: 18,
          padding: 26,
          maxWidth: 480,
          width: '92%',
          maxHeight: '90vh',
          overflowY: 'auto',
          animation: 'popIn 0.22s ease-out forwards',
        }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between" style={{ marginBottom: 18 }}>
          <h2 style={{ fontSize: '1rem', fontWeight: 800, color: 'var(--text)' }}>
            {title}
          </h2>
          <button
            onClick={onClose}
            className="flex items-center justify-center transition-colors hover:opacity-70"
            style={{
              width: 30,
              height: 30,
              borderRadius: 8,
              background: 'var(--bg)',
              border: 'none',
              cursor: 'pointer',
            }}
          >
            <X size={16} color="var(--text-sm)" />
          </button>
        </div>

        {/* Content */}
        <div>{children}</div>

        {/* Footer */}
        {footer && (
          <div
            className="flex gap-2 justify-end"
            style={{
              borderTop: '1px solid var(--border)',
              paddingTop: 14,
              marginTop: 18,
            }}
          >
            {footer}
          </div>
        )}
      </div>

      <style jsx global>{`
        @keyframes popIn {
          from {
            transform: scale(0.95) translateY(12px);
            opacity: 0;
          }
          to {
            transform: scale(1) translateY(0);
            opacity: 1;
          }
        }
      `}</style>
    </div>
  );
}
