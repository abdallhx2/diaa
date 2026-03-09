// ============================================================
// File: users.ts
// Purpose: خدمات API للمستخدمين — CRUD operations
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 2 — صفحات لوحة التحكم والمستخدمين
// ============================================================

// --- Required Imports ---
// import api from '@/services/api';
// import { User, UserCreateRequest, UserUpdateRequest, UsersResponse } from '@/types/user';

// --- Implementation Steps ---
// Step 1: دالة جلب قائمة المستخدمين
//   - export async function getUsers(filters?: { search?: string; role?: string; page?: number; limit?: number }): Promise<UsersResponse>
//   - const response = await api.get('/admin/users', { params: filters });
//   - return response.data;
//   - filters اختيارية: search (بحث بالاسم)، role (تصفية بالدور)، page، limit

// Step 2: دالة جلب مستخدم بالمعرف
//   - export async function getUserById(id: string): Promise<User>
//   - const response = await api.get(`/admin/users/${id}`);
//   - return response.data.data;  // أو response.data حسب بنية API

// Step 3: دالة إنشاء مستخدم جديد
//   - export async function createUser(data: UserCreateRequest): Promise<User>
//   - const response = await api.post('/admin/users', data);
//   - return response.data.data;

// Step 4: دالة تحديث بيانات مستخدم
//   - export async function updateUser(id: string, data: UserUpdateRequest): Promise<User>
//   - const response = await api.put(`/admin/users/${id}`, data);
//   - return response.data.data;

// Step 5: دالة حذف مستخدم
//   - export async function deleteUser(id: string): Promise<void>
//   - await api.delete(`/admin/users/${id}`);

// --- Notes ---
// - جميع الدوال تستخدم api instance من services/api.ts (token مُرفق تلقائياً)
// - بنية الاستجابة المتوقعة: { success: boolean, data: ..., message: string }
// - filters تُمرر كـ query params: GET /admin/users?search=أحمد&role=student&page=1&limit=10
// - الأخطاء تُعالج في المكون المستدعي عبر try/catch
// - يمكن إضافة caching باستخدام React Query / SWR مستقبلاً
