// ============================================================
// File: user.ts
// Purpose: TypeScript interfaces لبيانات المستخدمين
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Implementation Steps ---

// Step 1: تعريف interface المستخدم الأساسي
//   - export interface User {
//       id: string;              // معرف المستخدم (UUID أو auto-increment)
//       firebase_uid: string;    // معرف Firebase Authentication
//       role: 'student' | 'parent' | 'admin';  // دور المستخدم
//       name: string;            // الاسم الكامل
//       email: string;           // البريد الإلكتروني
//       phone?: string;          // رقم الهاتف (اختياري)
//       created_at: string;      // تاريخ الإنشاء (ISO 8601)
//       is_active: boolean;      // هل الحساب نشط؟
//     }

// Step 2: تعريف interface طلب إنشاء مستخدم
//   - export interface UserCreateRequest {
//       name: string;
//       email: string;
//       phone?: string;
//       role: 'student' | 'parent' | 'admin';
//       password: string;        // كلمة المرور (تُستخدم لإنشاء حساب Firebase)
//       is_active?: boolean;     // افتراضي: true
//     }

// Step 3: تعريف interface طلب تحديث مستخدم
//   - export interface UserUpdateRequest {
//       name?: string;
//       email?: string;
//       phone?: string;
//       role?: 'student' | 'parent' | 'admin';
//       is_active?: boolean;
//     }
//   - جميع الحقول اختيارية (Partial update)

// Step 4: تعريف interface استجابة قائمة المستخدمين
//   - export interface UsersResponse {
//       success: boolean;
//       data: User[];
//       message: string;
//       total?: number;          // إجمالي العدد (للـ pagination)
//       page?: number;
//       limit?: number;
//     }

// --- Notes ---
// - role محدد بـ union type: 'student' | 'parent' | 'admin'
// - firebase_uid يربط المستخدم المحلي بحساب Firebase
// - created_at يأتي كـ ISO 8601 string — استخدم new Date() أو date-fns لتحويله
// - password موجود فقط في CreateRequest — لا يُرجع من API أبداً
// - UsersResponse يتبع بنية الاستجابة الموحدة: { success, data, message }
