// ============================================================
// File: Modal.tsx
// Purpose: مكون النافذة المنبثقة - للتأكيدات والنماذج
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 1 — بناء مكونات UI الأساسية
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useEffect, useRef } from 'react';
// import { X } from 'lucide-react';

// --- Implementation Steps ---
// Step 1: تعريف Props
//   - interface ModalProps {
//       isOpen: boolean;
//       onClose: () => void;
//       title: string;
//       children: React.ReactNode;
//       footer?: React.ReactNode;    // أزرار أسفل النافذة (اختياري)
//     }

// Step 2: التحكم بفتح/إغلاق النافذة
//   - if (!isOpen) return null;
//   - أغلق عند الضغط على Escape:
//     useEffect → document.addEventListener('keydown', (e) => e.key === 'Escape' && onClose())
//   - أغلق عند النقر على الخلفية (backdrop)

// Step 3: بناء طبقة الخلفية (Overlay)
//   - <div className="fixed inset-0 z-50 flex items-center justify-center">
//   - <div className="fixed inset-0 bg-black/50" onClick={onClose} />  // backdrop

// Step 4: بناء بطاقة النافذة
//   - <div className="relative z-50 bg-white rounded-lg shadow-xl w-full max-w-md mx-4 animate-in">
//   - رأس النافذة: عنوان + زر إغلاق (X)
//     <div className="flex items-center justify-between p-4 border-b">
//       <h2 className="text-lg font-bold">{title}</h2>
//       <button onClick={onClose}><X size={20} /></button>
//     </div>
//   - محتوى النافذة: <div className="p-4">{children}</div>
//   - ذيل النافذة (اختياري): {footer && <div className="p-4 border-t flex gap-2 justify-end">{footer}</div>}

// Step 5: Animation (اختياري لكن مُحبذ)
//   - الظهور: animate-in — scale من 95% إلى 100% + opacity من 0 إلى 1
//   - يمكن استخدام Tailwind animation أو CSS keyframes
//   - الخلفية: transition من شفاف إلى bg-black/50

// Step 6: التصدير
//   - export default function Modal({ isOpen, onClose, title, children, footer }: ModalProps)

// --- Notes ---
// - z-50 لضمان ظهور النافذة فوق كل شيء
// - النقر على الخلفية يُغلق — لكن النقر على البطاقة لا يُغلق (e.stopPropagation)
// - Escape key للإغلاق — مهم للوصولية (accessibility)
// - max-w-md حجم مناسب — يمكن إضافة prop size لأحجام مختلفة
// - تأكد من تنظيف event listener في cleanup function لـ useEffect
// - يمكن استخدام Portal (createPortal) لعرض Modal خارج DOM tree الحالي
