// ============================================================
// File: lesson.ts
// Purpose: TypeScript interfaces لبيانات الدروس التعليمية
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Implementation Steps ---

// Step 1: تعريف interface الدرس الأساسي
//   - export interface Lesson {
//       id: string;              // معرف الدرس
//       title: string;           // عنوان الدرس
//       subject: string;         // المادة (لغتي، رياضيات، علوم...)
//       grade_level: string;     // المرحلة الدراسية (الأول، الثاني... السادس)
//       original_text: string;   // النص الأصلي للدرس
//       qr_code?: string;        // رمز QR المرتبط بالدرس (اختياري)
//       audio_url?: string;      // رابط الملف الصوتي (يُولد من الباك اند)
//       created_at: string;      // تاريخ الإنشاء (ISO 8601)
//     }

// Step 2: تعريف interface طلب إنشاء درس
//   - export interface LessonCreateRequest {
//       title: string;
//       subject: string;
//       grade_level: string;
//       original_text: string;
//       qr_code?: string;
//     }
//   - audio_url لا يُرسل — يُولد تلقائياً من الباك اند

// Step 3: تعريف interface طلب تحديث درس
//   - export interface LessonUpdateRequest {
//       title?: string;
//       subject?: string;
//       grade_level?: string;
//       original_text?: string;
//       qr_code?: string;
//     }
//   - جميع الحقول اختيارية (Partial update)

// --- Notes ---
// - subject: قيم ثابتة حالياً (لغتي، رياضيات، علوم، اجتماعيات، تربية إسلامية)
// - grade_level: الأول حتى السادس (المرحلة الابتدائية)
// - original_text: النص الأصلي الذي يُبنى عليه الدرس والأسئلة
// - audio_url: يُولد من الباك اند (text-to-speech) — للقراءة فقط في الفرونت
// - qr_code: رمز QR يمكن طباعته وربطه بالدرس في الكتاب
