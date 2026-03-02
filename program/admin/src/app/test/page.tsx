// ============================================================
// ملف اختبار أساسي — Admin Test Page
// الغرض: التأكد من أن المشروع يعمل + الاتصال بالـ Backend
// المسار: http://localhost:3000/test
// ============================================================

'use client';

import { useState } from 'react';

interface TestResult {
  name: string;
  status: 'pending' | 'success' | 'error' | 'warning';
  message: string;
}

export default function TestPage() {
  const [results, setResults] = useState<TestResult[]>([
    { name: 'Next.js', status: 'success', message: 'المشروع يعمل بنجاح' },
    { name: 'Backend API', status: 'pending', message: 'جاري الاختبار...' },
    { name: 'Firebase Auth', status: 'pending', message: 'جاري الاختبار...' },
  ]);
  const [testing, setTesting] = useState(false);

  const runTests = async () => {
    setTesting(true);

    // --- 1. اختبار Backend API ---
    try {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
      const res = await fetch(apiUrl, { method: 'GET' });

      if (res.ok) {
        updateResult('Backend API', 'success', `متصل — الحالة: ${res.status}`);
      } else {
        updateResult('Backend API', 'warning', `يستجيب لكن بحالة: ${res.status}`);
      }
    } catch {
      updateResult('Backend API', 'error', 'غير متصل — تأكد من تشغيل السيرفر');
    }

    // --- 2. اختبار Firebase ---
    try {
      const apiKey = process.env.NEXT_PUBLIC_FIREBASE_API_KEY;
      if (apiKey && apiKey !== 'your_key') {
        updateResult('Firebase Auth', 'success', 'مفتاح Firebase موجود');
      } else {
        updateResult('Firebase Auth', 'warning', 'عدّل NEXT_PUBLIC_FIREBASE_API_KEY في .env.local');
      }
    } catch {
      updateResult('Firebase Auth', 'error', 'فشل إعداد Firebase');
    }

    setTesting(false);
  };

  const updateResult = (name: string, status: TestResult['status'], message: string) => {
    setResults(prev => prev.map(r => r.name === name ? { ...r, status, message } : r));
  };

  const statusIcon = (status: TestResult['status']) => {
    switch (status) {
      case 'success': return '✅';
      case 'error': return '❌';
      case 'warning': return '⚠️';
      default: return '⏳';
    }
  };

  const statusColor = (status: TestResult['status']) => {
    switch (status) {
      case 'success': return 'border-green-300 bg-green-50';
      case 'error': return 'border-red-300 bg-red-50';
      case 'warning': return 'border-yellow-300 bg-yellow-50';
      default: return 'border-gray-200 bg-gray-50';
    }
  };

  return (
    <div dir="rtl" className="min-h-screen bg-gray-100 flex items-center justify-center p-6">
      <div className="bg-white rounded-2xl shadow-lg p-8 w-full max-w-md">
        <h1 className="text-2xl font-bold text-center mb-2">🔍 اختبار Edu Smart</h1>
        <p className="text-gray-500 text-center mb-8">لوحة تحكم المسؤول — اختبار الاتصال</p>

        <div className="space-y-3 mb-8">
          {results.map((r) => (
            <div key={r.name} className={`border rounded-xl p-4 ${statusColor(r.status)}`}>
              <div className="flex items-center gap-3">
                <span className="text-2xl">{statusIcon(r.status)}</span>
                <div>
                  <p className="font-bold">{r.name}</p>
                  <p className="text-sm text-gray-600">{r.message}</p>
                </div>
              </div>
            </div>
          ))}
        </div>

        <button
          onClick={runTests}
          disabled={testing}
          className="w-full bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 text-white font-bold py-3 px-6 rounded-xl transition"
        >
          {testing ? '⏳ جاري الاختبار...' : '🔄 بدء الاختبار'}
        </button>
      </div>
    </div>
  );
}
