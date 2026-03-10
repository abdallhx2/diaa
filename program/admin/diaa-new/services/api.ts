// ============================================================
// File: api.ts
// Purpose: إعداد Axios client مع interceptors للمصادقة ومعالجة الأخطاء
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// import axios from 'axios';
// import { getIdToken } from '@/services/auth';

// --- Implementation Steps ---
// Step 1: إنشاء Axios instance
//   - const api = axios.create({
//       baseURL: process.env.NEXT_PUBLIC_API_URL,  // مثال: 'http://localhost:8000/api'
//       headers: { 'Content-Type': 'application/json' },
//       timeout: 15000,  // 15 ثانية
//     });

// Step 2: إضافة Request Interceptor — إرفاق Firebase token
//   - api.interceptors.request.use(async (config) => {
//       const token = await getIdToken();
//       if (token) {
//         config.headers.Authorization = `Bearer ${token}`;
//       }
//       return config;
//     }, (error) => Promise.reject(error));
//   - هذا يُرفق token تلقائياً مع كل طلب

// Step 3: إضافة Response Interceptor — معالجة الأخطاء
//   - api.interceptors.response.use(
//       (response) => response,  // الاستجابة الناجحة تُمرر كما هي
//       (error) => {
//         if (error.response?.status === 401) {
//           // Token منتهي أو غير صالح → إعادة توجيه لتسجيل الدخول
//           window.location.href = '/';
//         }
//         // يمكن معالجة أخطاء أخرى هنا (403, 500, network error)
//         return Promise.reject(error);
//       }
//     );

// Step 4: تصدير الـ instance
//   - export default api;

// --- Notes ---
// - NEXT_PUBLIC_API_URL تُعرّف في .env.local
// - getIdToken() من Firebase Auth تُرجع token الحالي أو تُجدده تلقائياً
// - 401 يعني انتهاء صلاحية الـ token — إعادة توجيه لتسجيل الدخول
// - timeout: 15000 لتجنب الانتظار الطويل في حال بطء السيرفر
// - جميع الخدمات (users, lessons, quizzes, logs) تستخدم هذا الـ instance
// - يمكن إضافة retry logic لأخطاء الشبكة مستقبلاً
