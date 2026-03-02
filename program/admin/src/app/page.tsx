// ============================================================
// File: page.tsx
// Purpose: صفحة تسجيل الدخول الرئيسية للمسؤول - أول صفحة تظهر
// Owner: جود — Admin Lead
// Branch: feature/admin-core
// Week: 1 — بناء الهيكل الأساسي والمصادقة
// ============================================================

// --- Required Imports ---
// 'use client';
// import { useState } from 'react';
// import { useRouter } from 'next/navigation';
// import { signIn } from '@/services/auth';        // Firebase signInWithEmailAndPassword
// import api from '@/services/api';                 // Axios instance
// import Button from '@/components/ui/Button';
// import Input from '@/components/ui/Input';

// --- Implementation Steps ---
// Step 1: إنشاء state variables
//   - email: string, password: string
//   - loading: boolean (حالة التحميل)
//   - error: string (رسالة الخطأ)

// Step 2: بناء واجهة تسجيل الدخول
//   - شاشة كاملة بمركز الصفحة: min-h-screen flex items-center justify-center bg-gray-50
//   - بطاقة بيضاء في المنتصف: bg-white p-8 rounded-lg shadow-md w-full max-w-md

// Step 3: إضافة شعار التطبيق والعنوان
//   - شعار Edu Smart في الأعلى (صورة أو نص)
//   - عنوان "لوحة تحكم المسؤول" تحت الشعار

// Step 4: إنشاء نموذج تسجيل الدخول
//   - حقل البريد الإلكتروني: <Input label="البريد الإلكتروني" type="email" />
//   - حقل كلمة المرور: <Input label="كلمة المرور" type="password" />
//   - زر تسجيل الدخول: <Button isLoading={loading}>تسجيل الدخول</Button>

// Step 5: معالجة إرسال النموذج (handleSubmit)
//   - a) setLoading(true), setError('')
//   - b) استدعاء signIn(email, password) من Firebase Auth
//   - c) التحقق من الدور: GET /api/auth/me → response.data.role
//   - d) إذا role !== 'admin' → setError('ليس لديك صلاحية الوصول')
//   - e) إذا admin → router.push('/dashboard')
//   - f) في حالة خطأ: setError('البريد الإلكتروني أو كلمة المرور غير صحيحة')
//   - g) finally: setLoading(false)

// Step 6: عرض رسالة الخطأ
//   - {error && <p className="text-red-500 text-sm text-center">{error}</p>}

// --- Notes ---
// - هذه الصفحة يجب أن تكون 'use client' لأنها تستخدم useState و events
// - Firebase Auth يرجع token يُرسل تلقائياً مع كل request عبر Axios interceptor
// - التحقق من الدور ضروري — ليس كل مستخدم Firebase هو admin
// - استخدم try/catch للتعامل مع أخطاء Firebase المختلفة
// - فكر في إضافة "نسيت كلمة المرور" كميزة مستقبلية
