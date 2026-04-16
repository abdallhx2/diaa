// ============================================================
// File: quiz.ts
// Purpose: TypeScript interfaces لبيانات الاختبارات والأسئلة
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Implementation Steps ---

// Step 1: تعريف interface السؤال الأساسي
//   - export interface Quiz {
//       id: string;                        // معرف السؤال
//       lesson_id: string;                 // معرف الدرس المرتبط
//       quiz_type: 'reading' | 'writing' | 'comprehension';  // نوع الاختبار
//       question_text: string;             // نص السؤال
//       options: string[];                 // الخيارات (3-4 خيارات)
//       correct_answer: string;            // الإجابة الصحيحة (أحد الخيارات)
//     }

// Step 2: تعريف interface طلب إنشاء سؤال
//   - export interface QuizCreateRequest {
//       lesson_id: string;
//       quiz_type: 'reading' | 'writing' | 'comprehension';
//       question_text: string;
//       options: string[];                 // مصفوفة نصية: ['خيار 1', 'خيار 2', 'خيار 3']
//       correct_answer: string;
//     }

// Step 3: تعريف interface نتيجة اختبار الطالب
//   - export interface QuizResult {
//       id: string;                        // معرف النتيجة
//       student_id: string;                // معرف الطالب
//       quiz_id: string;                   // معرف السؤال
//       score: number;                     // الدرجة (0 أو 1 لكل سؤال، أو نسبة مئوية)
//       answers_detail: Record<string, any>;  // تفاصيل الإجابات
//       taken_at: string;                  // تاريخ أداء الاختبار (ISO 8601)
//     }

// --- Notes ---
// - quiz_type ثلاثة أنواع:
//   - reading: أسئلة القراءة
//   - writing: أسئلة الكتابة
//   - comprehension: أسئلة فهم المقروء
// - options: مصفوفة بحد أدنى 3 وحد أقصى 4 عناصر
// - correct_answer يجب أن يكون أحد عناصر options بالضبط
// - QuizResult يُستخدم لعرض نتائج الطلاب (للقراءة فقط في لوحة التحكم)
// - answers_detail: كائن مرن يحتوي تفاصيل إضافية عن إجابات الطالب
