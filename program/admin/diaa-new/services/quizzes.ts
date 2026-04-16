// ============================================================
// File: quizzes.ts
// Purpose: خدمات API للاختبارات والأسئلة — CRUD operations
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// import api from '@/services/api';
// import { Quiz, QuizCreateRequest } from '@/types/quiz';

// --- Implementation Steps ---
// Step 1: دالة جلب قائمة الأسئلة
//   - export async function getQuizzes(filters?: { quiz_type?: string; lesson_id?: string }): Promise<Quiz[]>
//   - const response = await api.get('/admin/quizzes', { params: filters });
//   - return response.data.data;
//   - أو: GET /api/quizzes إذا كان الـ endpoint مشترك

// Step 2: دالة إنشاء سؤال جديد
//   - export async function createQuiz(data: QuizCreateRequest): Promise<Quiz>
//   - const response = await api.post('/admin/quizzes', data);
//   - return response.data.data;

// Step 3: دالة تحديث سؤال
//   - export async function updateQuiz(id: string, data: Partial<QuizCreateRequest>): Promise<Quiz>
//   - const response = await api.put(`/admin/quizzes/${id}`, data);
//   - return response.data.data;

// Step 4: دالة حذف سؤال
//   - export async function deleteQuiz(id: string): Promise<void>
//   - await api.delete(`/admin/quizzes/${id}`);

// --- Notes ---
// - الـ endpoint قد يكون /admin/quizzes أو /quizzes — تحقق من الباك اند
// - QuizCreateRequest يشمل: lesson_id, quiz_type, question_text, options[], correct_answer
// - options يُرسل كـ string[] (مصفوفة نصوص)
// - correct_answer يجب أن يكون أحد الخيارات
// - يمكن إضافة getQuizzesByLesson(lessonId) كاختصار
