// ============================================================
// File: log.ts
// Purpose: TypeScript interfaces لسجلات النظام
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Implementation Steps ---

// Step 1: تعريف interface سجل النظام
//   - export interface SystemLog {
//       id: string;                          // معرف السجل
//       user_id: string;                     // معرف المستخدم الذي قام بالإجراء
//       user_name: string;                   // اسم المستخدم (للعرض المباشر)
//       action: string;                      // نوع الإجراء (login, create_user, update_lesson, delete_quiz...)
//       details: Record<string, any>;        // تفاصيل إضافية عن الإجراء (كائن مرن)
//       created_at: string;                  // تاريخ ووقت الإجراء (ISO 8601)
//     }

// Step 2: تعريف interface فلاتر السجلات
//   - export interface LogsFilter {
//       date_from?: string;                  // بداية الفترة (YYYY-MM-DD)
//       date_to?: string;                    // نهاية الفترة (YYYY-MM-DD)
//       action_type?: string;                // نوع الإجراء للتصفية
//       user_id?: string;                    // تصفية حسب المستخدم
//     }

// --- Notes ---
// - السجلات للقراءة فقط — تُنشأ تلقائياً من الباك اند
// - action: قيم مثل 'login', 'logout', 'create_user', 'update_user', 'delete_user',
//   'create_lesson', 'update_lesson', 'delete_lesson', 'create_quiz', etc.
// - details: كائن مرن Record<string, any> — قد يحتوي:
//   - { target_id: '123', target_name: 'الدرس الأول', changes: {...} }
// - user_name مُضمّن في السجل لتسهيل العرض بدون join مع جدول المستخدمين
// - date_from و date_to بصيغة YYYY-MM-DD — تُرسل كـ query params
// - يمكن إضافة LogsResponse interface إذا كانت بنية الاستجابة مختلفة
