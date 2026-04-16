// ============================================================
// File: auth.ts
// Purpose: خدمات Firebase Authentication — تسجيل الدخول والخروج وإدارة الجلسة
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// import { initializeApp, getApps } from 'firebase/app';
// import {
//   getAuth,
//   signInWithEmailAndPassword,
//   signOut as firebaseSignOut,
//   onAuthStateChanged as firebaseOnAuthStateChanged,
//   User,
// } from 'firebase/auth';

// --- Implementation Steps ---
// Step 1: تعريف Firebase config من متغيرات البيئة
//   - const firebaseConfig = {
//       apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
//       authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
//       projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
//     };

// Step 2: تهيئة Firebase App (مرة واحدة فقط)
//   - const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];
//   - const auth = getAuth(app);
//   - getApps().length === 0 يمنع التهيئة المتكررة في Next.js

// Step 3: دالة تسجيل الدخول
//   - export async function signIn(email: string, password: string): Promise<User>
//   - const userCredential = await signInWithEmailAndPassword(auth, email, password);
//   - return userCredential.user;

// Step 4: دالة تسجيل الخروج
//   - export async function signOut(): Promise<void>
//   - await firebaseSignOut(auth);

// Step 5: دالة الحصول على المستخدم الحالي
//   - export function getCurrentUser(): User | null
//   - return auth.currentUser;

// Step 6: دالة الحصول على ID Token
//   - export async function getIdToken(): Promise<string | null>
//   - const user = auth.currentUser;
//   - if (!user) return null;
//   - return await user.getIdToken();
//   - هذه الدالة تُستخدم في Axios interceptor

// Step 7: دالة مراقبة حالة المصادقة
//   - export function onAuthStateChanged(callback: (user: User | null) => void): () => void
//   - return firebaseOnAuthStateChanged(auth, callback);
//   - تُرجع unsubscribe function لتنظيف listener

// --- Notes ---
// - Firebase config يُحمّل من NEXT_PUBLIC_ env vars (متاحة في client)
// - getApps() check ضروري لأن Next.js قد يُعيد تهيئة الوحدة عدة مرات (HMR)
// - getIdToken() تُجدد الـ token تلقائياً إذا انتهت صلاحيته
// - onAuthStateChanged تُستخدم في DashboardLayout و AuthProvider
// - لا تخزن token في localStorage — Firebase يُديره تلقائياً
// - يمكن إضافة resetPassword(email) مستقبلاً
