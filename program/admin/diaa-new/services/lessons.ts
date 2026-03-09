// ============================================================
// File: lessons.ts
// Purpose: خدمات API للدروس التعليمية — CRUD operations
// Owner: جود2 — Admin Developer
// Branch: feature/admin-content
// Week: 2 — صفحات المحتوى التعليمي
// ============================================================

// --- Required Imports ---
// import api from '@/services/api';
// import { Lesson, LessonCreateRequest, LessonUpdateRequest } from '@/types/lesson';

// --- Implementation Steps ---
// Step 1: دالة جلب قائمة الدروس
//   - export async function getLessons(filters?: { search?: string; subject?: string; grade?: string }): Promise<Lesson[]>
//   - const response = await api.get('/admin/lessons', { params: filters });
//   - return response.data.data;
//   - filters: search (بحث بالعنوان)، subject (المادة)، grade (المرحلة)

// Step 2: دالة جلب درس بالمعرف
//   - export async function getLessonById(id: string): Promise<Lesson>
//   - const response = await api.get(`/admin/lessons/${id}`);
//   - return response.data.data;

// Step 3: دالة إنشاء درس جديد
//   - export async function createLesson(data: LessonCreateRequest): Promise<Lesson>
//   - const response = await api.post('/admin/lessons', data);
//   - return response.data.data;

// Step 4: دالة تحديث درس
//   - export async function updateLesson(id: string, data: LessonUpdateRequest): Promise<Lesson>
//   - const response = await api.put(`/admin/lessons/${id}`, data);
//   - return response.data.data;

// Step 5: دالة حذف درس
//   - export async function deleteLesson(id: string): Promise<void>
//   - await api.delete(`/admin/lessons/${id}`);

// --- Notes ---
// - نفس بنية services/users.ts — CRUD قياسي
// - عند حذف درس: الباك اند يحذف الأسئلة المرتبطة تلقائياً
// - getLessons بدون filters تُرجع كل الدروس
// - يمكن إضافة getLessonsBySubject أو getLessonsByGrade كاختصارات
// - audio_url يُولد من الباك اند — لا يُرسل من الفرونت
